/* 
  events.pde
  Events contains all event functions for controls and moveFootballLED because I'm afraid to move it after the last mishap when I was organizing methods and github didn't like it.
  All events should be assigned to at least one control in gui.pde
  
  All events follow a similar naming convention to the one described in gui.pde for the controls
*/

//Track main button start click, fires for both track and football start click. The logic that is ran depends on which title is visible.
//For track, if the verifyCTIInput function returns true and the player count is not equal to zero, initialize all variables for running track logic.
public void tmb_start_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  if (tml_title.isVisible()) {
    if (verifyCTInput() == true) {
      if ((numPlayers = getPlayerCount()) == 0) {
        //player count is zero, do nothing
      } else {
        //player count is greater than zero, so initialize and run
        //Set needed variables
        reset();
        position = 0;
        startTime = System.nanoTime();
        //Initialize all arrays for all runners
        toClear = new boolean[numPlayers];
        match = new boolean[numPlayers];
        lastPositions = new double[numPlayers];
        lastTimes = new double[numPlayers];
        targetTime = new double[numPlayers];
        lapCounter = new int[numPlayers];
        stillRunning = new boolean[numPlayers];
        pixelPositions = new long[numPlayers];
        for (int temp=0; temp<numPlayers; temp++) {
           //for all arrays, iterate through all values to set to initial values
           toClear[temp] = false;
           match[temp] = false;                                                      //used to determine if match in pixel location in pusher
           stillRunning[temp] = true;                                                //used to determine when to stop running
           pixelPositions[temp] = 0;                                                 
           lapCounter[temp] = Integer.parseInt(tmt_totalNOL.getText());              //initially all are set to number of laps
           tm_lapR[temp].setText("" + lapCounter[temp]);                             //change initial number of laps to input
           lastPositions[temp] = 0;                                                  //used to light LEDs
           lastTimes[temp] = startTime;                                              //used to determine elapsed time
           targetTime[temp] = Double.parseDouble(tmt_desiredTimes[temp].getText());  //used for velocity
        }
        trackLength = Float.parseFloat(tmt_trackL.getText());                        //used in multiple calculations
  
        startPosition = led[0].getX();
        for (int i=0; i<numPlayers; i++) {
          led[i].setAlpha(255);      //make virtual led visible
        }
        running=true;
        updateVariables();           //start running updateVariables 
      }
    }
  } else if (fml_title.isVisible()) {
    reset();
    running=true;
    targetTime = new double[1]; 
    targetTime[0] = Double.parseDouble(fmt_desiredTime.getText());
    startTime = System.nanoTime();
    startPosition = football_led.getX();
    football_led.setAlpha(255);
    updateVariables();
  }
}

//Desired lap time text field change. Triggered when any text in the desired lap time text fields change
//Calls update runner speeds to update the speeds used in updateVariables() calculations
public void desiredLT_change(GTextField source, GEvent event) {
  println("desiredLapTime change - GTextField event occured " + System.currentTimeMillis()%10000000 );
  if (running) {  //if the program is not running, there is no need to update anything
                  //if the program is running, nums should be valid data, so use it to change targetTime[]
  updateRunnerSpeeds();
  }   
}

//Changes to visibility for new gui page
public void titlePaigeReturn_click(GButton source, GEvent event) {
  println("titlePaigeButton - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTP();
}

//Method text fields are linked to initially if no other method is made for them yet
//This is done to avoid error output
public void noTextEventYet(GTextField source, GEvent event) {
  println("Action received for GTextField: \"" + source.getText() + "\" but no event set for GTextField");
}

//Method buttons are linked to initially if no other method is made for them yet
//This is done to avoid error output
public void noButtonEventYet(GButton source, GEvent event) {
  println("Action received for GButton: \"" + source.getText() + "\" but no event set for button");
}

//Method image buttons are linked to initially if no other method is made for them yet
//This is done to avoid error output
public void noImageButtonEventYet(GImageButton source, GEvent event) {
  println("Action received for GImageButton, but no event set for image button");
}

//Changes to visibility for new gui page
public void tb_football_click(GButton source, GEvent event) {
  println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showFootballTP();
}

//Changes to visibility for new gui page
public void ftb_forty_click(GButton source, GEvent event) {
  println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showFootballMP();
}

//Reset track/football main page button click
//If track, sets running to false, sets all led lights invisible. The start button re-initializes all variables,
//so no need to go scrub all of them
public void tmb_reset_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  reset();
} 

//Changes to visibility for new gui page
public void tb_track_click(GButton source, GEvent event) {
  println("tb_track click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTrackMP();
  tmt_desiredLT1.setFocus(true);
}

//Changes to visibility for new gui page
public void cb_click(GButton source, GEvent event) {
  println("cb_click (" + source.getText() + ") - GButton event occured" + System.currentTimeMillis()%1000000);
  removeAll();
  showTrackMP();
}

public void moveFootballLED(GButton light, double[] targetTime) {
  long currentTime = System.nanoTime();
  long elapsed = currentTime-startTime;
  elapsed_seconds = elapsed/1000000000.0;
  velocity=(40/targetTime[0])*(1.0+computedSpeedIncrease/100.0);
  position = (velocity*elapsed_seconds);//position in yards
  float p =(float) position;
  float ledTrackLength = football_track.getWidth();
  float ledPosition = p/40*ledTrackLength;
  //  if (led.getX()<track.getX()+track.getWidth()-track.getHeight()/2) {
  if (ledPosition<ledTrackLength) {
    light.moveTo(startPosition+ledPosition, light.getY());
  }
  else {
    reset();
  }
}

//Track main page addperson click
//Determines number of runners already initialized. Feeds number to trackAddPlayer (helper.pde) to add player and change gui
public void tmb_addPerson_click(GButton source, GEvent event) {
  //find which player was added
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
    throw new Error("Error in addPlayer -> player not found");
  }
  println("tmb_addPerson_click - GButton event occured: player " + player + " clicked");
  trackAddPlayer(player);
}


public void tmb_zero_click(GButton source, GEvent event) {
  //find which player was added
  int player = findPlayerNumber(source.getY());
    //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
    throw new Error("Error in zero_click -> player not found");
  }
  println("tmb_zero_click - GButton event occured: player " + player + " clicked");
  toClear[player-1]=true;
}

//Track main page removeperson click
//Determines number of runners already initialized. Feeds number to trackRemovePlayer (helper.pde) to remove player and change gui
public void tmb_removePerson_click(GButton source, GEvent event) {
  //find which player was removed
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
    throw new Error("Error in removePlayer -> player not found");
  }
  println("tmb_removePerson_click - GButton event occured: player " + player + " clicked");
  trackRemovePlayer(player);
}

//Track main page adjust desired time up click
//Determine which player click was for by using button location, then feed to adjustTime (helper.pde)
//Finally, update runner speeds to push changes into logic in updateVariables()
public void tmb_adjustU_click(GImageButton source, GEvent event) {
  //find which player is adjusted
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
    throw new Error("Error in adjust_click -> player not found");
  }
  println("tmb_adjustU_click - GButton event occured: player " + player + " clicked");
  adjustTime(player, "UP");
  updateRunnerSpeeds();
}

//Track main page adjust desired time down click
//Determine which player click was for by using button location, then feed to adjustTime (helper.pde)
//Finally, update runner speeds to push changes into logic in updateVariables()
public void tmb_adjustD_click(GImageButton source, GEvent event) {
  //find which player is adjusted
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
    throw new Error("Error in adjust_click -> player not found");
  }
  println("tmb_adjustD_click - GButton event occured: player " + player + " clicked");
  adjustTime(player, "DOWN");
  updateRunnerSpeeds();
}

public void fmd_choosePosition_click(GDropList source, GEvent event) {
  float[] positionTimes = {Float.parseFloat(fmt_desiredTime.getText()), 4.55, 4.55, 4.59, 4.62, 4.74, 4.77, 4.80, 4.80, 4.87, 4.88, 5.13, 5.30, 5.32, 5.36};
  int positionIndex = fmd_choosePosition.getSelectedIndex();
  
  
  fmt_desiredTime.setText(Float.toString(positionTimes[positionIndex]));  

  println("fmd_choosePosition_click - GDropList event occured: player " + fmd_choosePosition.getSelectedText() + " clicked");
}

public void fmt_desiredTime_change(GTextField source, GEvent event) {
  println("fmt_desiredTime_change - GTextField event occured " + System.currentTimeMillis()%10000000 );
  fmd_choosePosition.setSelected(0);
}

