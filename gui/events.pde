public void tmb_start_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  if (tml_title.isVisible()) {
    if (verifyCTInput() == true) {
      running=true;
      
      //Set needed variables
      position = 0;
      startTime = System.nanoTime();
      if ((numPlayers = getPlayerCount()) == 0) {
        running = false;
      } else {
        tml_remainingNOL.setText("Lap Number"); 
        lastPositions = new double[numPlayers];
        lastTimes = new double[numPlayers];
        targetTime = new double[numPlayers];
        lapCounter = new int[numPlayers];
        stillRunning = new boolean[numPlayers];
        pixelPositions = new long[numPlayers];
        for (int temp=0; temp<numPlayers; temp++) {
           stillRunning[temp] = true;
           pixelPositions[temp] = 0;
           lapCounter[temp] = Integer.parseInt(tmt_totalNOL.getText());
           tm_lapR[temp].setText("" + lapCounter[temp]);
           lastPositions[temp] = 0; 
           lastTimes[temp] = startTime;
           targetTime[temp] = Double.parseDouble(tmt_desiredTimes[temp].getText());
           println("target time: " + targetTime[temp]);
        }
        trackLength = Float.parseFloat(tmt_trackL.getText());
  
        startPosition = led[0].getX();
        for (int i=0; i<numPlayers; i++) {
          led[i].setAlpha(255);
        }
        updateVariables();
      }
    }
  } else if (fml_title.isVisible()) {
    running=true;
    targetTime = new double[1]; 
    targetTime[0] = Double.parseDouble(fmt_desiredTime.getText());
    startTime = System.nanoTime();
    startPosition = football_led.getX();
    football_led.setAlpha(255);
    updateVariables();
  }
}

public void desiredLT_change(GTextField source, GEvent event) {
  println("desiredLapTime change - GTextField event occured " + System.currentTimeMillis()%10000000 );
  if (running) {  //if the program is not running, there is no need to update anything
                  //if the program is running, numPlayers should be valid data, so use it to change targetTime[]
  updateRunnerSpeeds();
  }   
}


public void titlePaigeReturn_click(GButton source, GEvent event) {
  println("titlePaigeButton - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTP();
}

public void noTextEventYet(GTextField source, GEvent event) {
  println("Action received for GTextField: \"" + source.getText() + "\" but no event set for GTextField");
}

public void noButtonEventYet(GButton source, GEvent event) {
  println("Action received for GButton: \"" + source.getText() + "\" but no event set for button");
}

public void noImageButtonEventYet(GImageButton source, GEvent event) {
  println("Action received for GImageButton, but no event set for image button");
}

public void tb_football_click(GButton source, GEvent event) {
  println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showFootballTP();
}

public void ftb_forty_click(GButton source, GEvent event) {
  println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showFootballMP();
}

public void tmb_reset_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  running=false;
  if (tml_title.isVisible()) { 
    for (int i=0; i<led.length; i++) {
      led[i].setAlpha(0);
      led[i].moveTo(track.getX()+(track.getHeight()/2), track.getY()+track.getHeight());
    }
  } else if (fml_title.isVisible()) {
    football_led.setAlpha(0);
    football_led.moveTo(football_track.getX(), football_track.getY()-football_led_height);
  }
} 

public void tb_track_click(GButton source, GEvent event) {
  println("tb_track click - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTrackMP();
  tmt_desiredLT1.setFocus(true);
}

public void cb_click(GButton source, GEvent event) {
  println("cb_click (" + source.getText() + ") - GButton event occured" + System.currentTimeMillis()%1000000);
  removeAll();
  showTrackMP();
}

public void moveLED(GButton[] light, double[] targetTime) {
  float ledTrackLength = (track.getWidth()-track.getHeight())*2+pi*track.getHeight();
  for (int i=0; i<numPlayers; i++) {
    long currentTime = System.nanoTime();
    long elapsed = currentTime-startTime;
    position = lastPositions[i];
    float p =(float) position;
    float ledPosition = p/trackLength*ledTrackLength;

    if (ledPosition<track.getWidth()-track.getHeight()) {
      light[i].moveTo(startPosition+ledPosition-light[i].getWidth(), light[i].getY());/////////////////////////////////////
    } else if ((track.getWidth()-track.getHeight())<ledPosition && ledPosition<(track.getWidth()-track.getHeight()+track.getHeight()*pi/4)) {
      float s = (ledPosition - (track.getWidth()-track.getHeight()));
      float theta = s/(track.getHeight()/2)+pi*3/2;
      float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
      float centerPointY1 = track.getY()+track.getHeight()/2;
      light[i].moveTo(centerPointX1+cos(theta)*track.getHeight()/2-light[i].getWidth()+light[i].getWidth()/(pi/2)*(theta-3*pi/2), centerPointY1-sin(theta)*track.getHeight()/2);/////////////////////////
    } else if (ledPosition>(track.getWidth()-track.getHeight()+track.getHeight()*pi/4) && ledPosition<(track.getWidth()-track.getHeight()+track.getHeight()*pi/2)) {
      float s = (ledPosition - (track.getWidth()-track.getHeight()));
      float theta = s/(track.getHeight()/2)+pi*3/2;
      float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
      float centerPointY1 = track.getY()+track.getHeight()/2;
      light[i].moveTo(centerPointX1+cos(theta)*track.getHeight()/2, centerPointY1-sin(theta)*track.getHeight()/2-light[i].getHeight()/(pi/2)*(theta-2*pi));//////////////////////////////////////
    } else if (ledPosition>(track.getWidth()-track.getHeight()+track.getHeight()*pi/2) && ledPosition<((track.getWidth()-track.getHeight())*2+track.getHeight()*pi/2)) {
      light[i].moveTo(startPosition+((track.getWidth()-track.getHeight())*2+track.getHeight()*pi/2)-ledPosition, light[i].getY());
    } else if (ledPosition>((track.getWidth()-track.getHeight())*2+track.getHeight()*pi/2) && ledPosition<((track.getWidth()-track.getHeight())*2+track.getHeight()*pi*3/4)) {
      float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*pi/2);
      float theta = s/(track.getHeight()/2)+pi*3/2;
      float centerPointX2 = track.getX()+track.getHeight()/2;
      float centerPointY2 = track.getY()+track.getHeight()/2;
      light[i].moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light[i].getWidth()/(pi/2)*(theta-3*pi/2), centerPointY2+sin(theta)*track.getHeight()/2-light[i].getHeight());//////////////////////////////////////      
    } else if (ledPosition>((track.getWidth()-track.getHeight())*2+track.getHeight()*pi*3/4) && ledPosition<((track.getWidth()-track.getHeight())*2+track.getHeight()*pi)) {
      float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*pi/2);
      float theta = s/(track.getHeight()/2)+pi*3/2;
      float centerPointX2 = track.getX()+track.getHeight()/2;
      float centerPointY2 = track.getY()+track.getHeight()/2;
      light[i].moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light[i].getWidth(), centerPointY2+sin(theta)*track.getHeight()/2-light[i].getHeight()+light[i].getHeight()/(pi/2)*(theta-2*pi));///////////////////////      
    }
  }
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
}

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

