/*
  helper.pde
  Helper functions for rest of code base. General order of functions is given below. 
*/

//Ordered table of contents for helper functions
//1. Helper functions for logic
//2. Helper functions for drawing controls
//3. Helper functions for showing/hiding controls 

//=============================================================================================================
//1. Helper functions for logic

//Returns number of set runners, which is used in most of the code logic to decide how many iterations of logic to perform
//Determines length of text in each desiredLT text field in desiredTimes array. If the field has text, it tries to parse
//the text into a double. If that works and it parses to be greater than zero, add to count. Otherwise, break
//The code will break on the first 0 or non-numeric entry, so if runner one has time zero and runner two has time 10, the 
//player count will be 0
private int getPlayerCount() {
  int count = 0;
  for (GTextField temp : tmt_desiredTimes) {
    if ((temp.getText().length() != 0) && Double.parseDouble(temp.getText()) > 0.01) { //I hate double comparasions -CT
      count++;
    } else {
      break;
    } 
  }
  return count;
}

//Verify Control Track Input (CTI) for track gui. If all controls have valid input, returns true. Otherwise, returns false
//Returns false and prints some custom error message if any of the following are true:
//--desired lap time for first entry is empty (if equal to zero, player count catches it and returns 0)
//--desired lap time has text that is non numeric
//--total number of laps is empty, non-numeric, or too big
//--track length is empty, non-numeric, or too big
private boolean verifyCTInput() {
  //try parsing all required input fields. If error, return false. If all required input is provided, return true
  try {
    //if desired lap time for first is empty, "Desired Lap Time must be given"
    if (tmt_desiredLT1.getText().length() == 0) {
        throw new Exception("Desired Lap Time must be given for at least the first runner"); 
    }
    //if any desiredLT1/2/3/4 has something non-numeric, "Please verify only numerical entries are given in desired laptime text boxes"
   Double.parseDouble(tmt_desiredLT1.getText());   
    if (tmt_desiredLT2.getText().length() != 0) {
      Double.parseDouble(tmt_desiredLT2.getText());
      if (tmt_desiredLT3.getText().length() != 0) {
         Double.parseDouble(tmt_desiredLT3.getText());
        if (tmt_desiredLT4.getText().length() != 0) {
           Double.parseDouble(tmt_desiredLT4.getText());
        } 
      }
    }
    //if tmt_totalNOL is empty or if it is non-numeric, "Please enter a numeric value 1-100 in total number of laps"
    if (tmt_totalNOL.getText().length() == 0) {
        throw new Exception("Please enter a numeric value 1-100 in total number of laps");
    } else {
      double numLaps = Double.parseDouble(tmt_totalNOL.getText());
      if (numLaps < 0 || numLaps > 100) {
         throw new Exception("Please enter a numeric value 1-100 in total number of laps");
      }    
    }
    //if tmt_trackL is empty, non-numeric, or too large/small
    if (tmt_trackL.getText().length() == 0) {
       throw new Exception("Please enter a numeric value 10-500 in track length"); 
    } else {
       trackLength = Float.parseFloat(tmt_trackL.getText());
      if (trackLength < 10 || trackLength > 500) {
         throw new Exception("Please enter a numeric value 10-500 in track length");
      } 
    }
    return true;
    //Catch certain errors and print helpful error message
  } catch (NumberFormatException e) {
    //Error in parsing some input field as a double
    println("Error in verifyCTIInput: Please verify only numerical entries are given in all text boxes");
    
  } catch (Exception e) {
    //Custom exception thrown, pring error message
    println("Error in verifyCTIInput: " + e.toString());
  }
  return false; 
}

//Updates array that holds each runners desired lap time with values in text boxes
private void updateRunnerSpeeds() {
    for (int temp=0; temp<numPlayers; temp++) {
      targetTime[temp] = Double.parseDouble(tmt_desiredTimes[temp].getText());
    }
}

//Takes player number and direction as input, and adjusts the desired lap time for that player in that direction by 0.1 s
private void adjustTime(int player, String direction) {
  GTextField thisLT = tmt_desiredTimes[player-1];
  double time;
  try {
    //in case non-numeric value is in that desired lap time text box
    time = Double.parseDouble(thisLT.getText());
  } 
  catch (NumberFormatException e) {
    println("Valid number not in desired lap time for player " + player + ". Resetting lap time to 0.");
    time = 0;
  }
  //if up, increase time. If down, decrease time
  if (direction == "UP") {
    time += 0.1;
  } else {
    time -= 0.1;
    //must check if time below zero after subtraction. Cannot check if time == 0.1 b/c of double math
    if (time < .1000001) {
      time = .1;
    }
  }
  //Set that lap time text field to the calculated time
  thisLT.setText(String.format("%.2f", time));
}

//Takes a integer of height, returns player that is at that height in the gui layout
//Returns -1 if player index not found. If this happens, check the player heights in gui.pde
//Used in add/remove person click to determine who to add/remove
private int findPlayerNumber(float y){
  int player = 1;
  for (int temp : rowHeight) {
    if (temp == y + 2) {
      break;
    } else {
      player++;
    }
  }
  //return -1 if not found
  if (player > rowHeight.length) {
     player = -1; 
  }
  return player;
}

//=============================================================================================================
//2. Helper functions for drawing controls
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

private GLabel makeTitle(int p0, int p1, int p2, int p3, int fontSize, GLabel title, String text, GAlign horizAlign, GAlign vertAlign, Boolean isVisible) {
  title = new GLabel(this, p0, p1, p2, p3); 
  title.setText(text);
  title.setOpaque(false);
  title.setFont(new Font("SansSerif", Font.PLAIN, fontSize));
  title.setVisible(isVisible);
  //Make label white
  title.setLocalColorScheme(color(1,1,1));
  title.setTextAlign(horizAlign, vertAlign);
  return title;
}
private GButton makeButton(int p0, int p1, int p2, int p3, GButton button, String text, Boolean isVisible, String eventHandler) {
  button = new GButton(this, p0, p1, p2, p3);
  button.setText(text);
  button.setFont(new Font("SansSerif", Font.PLAIN, 30));
  button.setVisible(isVisible);
  button.addEventHandler(this, eventHandler);
  return button;
}
private GImageButton makeImageButton(int p0, int p1, int p2, int p3, GImageButton button, Boolean isVisible, String eventHandler, String img) {
  String[] images = new String[1];
  images[0] = img;
  button = new GImageButton(this, p0, p1, p2, p3, images);
  button.setVisible(false);
  button.addEventHandler(this, eventHandler); 
  return button;
}
private GTextField makeTextField(int p0, int p1, int p2, int p3, int textSize, GTextField textField, String text, Boolean isVisible, String eventHandler) {
  textField = new GTextField(this, p0, p1, p2, p3);
  textField.setText(text);
  textField.setFont(new Font("SansSerif", Font.PLAIN, textSize));
  textField.setDefaultText(text);
  textField.setOpaque(true);
  textField.addEventHandler(this, eventHandler);
  textField.setVisible(isVisible);
  
  return textField;
}

//=============================================================================================================
//Helper functions for showing/hiding controls
public void removeAll(){
  for (List<GLabel> tempArray : labels) {
     for (GLabel tempLabel : tempArray) {
        tempLabel.setVisible(false);
     } 
  }
  for (List<GButton> tempArray : buttons) {
     for (GButton tempButton : tempArray) {
        tempButton.setVisible(false);
     } 
  }
  for (List<GTextField> tempArray : textFields) {
     for (GTextField tempTextField : tempArray) {
        tempTextField.setVisible(false);
     } 
  }
  for (List<GImageButton> tempArray : imageButtons) {
     for (GImageButton temp : tempArray) {
        temp.setVisible(false);
     } 
  }
  tmc_paceAssist.setVisible(false);
  for (GButton temp: led){
    temp.setAlpha(0);
  }
  football_led.setAlpha(0);   
}

public void showFootballTP() {
   for (GLabel temp : ft_labels) {
      temp.setVisible(true);
   }
  for (GButton temp : ft_buttons) {
     temp.setVisible(true);
  } 
}

public void showTrackMP() {
  for (GLabel temp : tm_labels) {
     temp.setVisible(true); 
  }
  for (GButton temp : tm_buttons) {
     temp.setVisible(true); 
  }
  for (GImageButton temp : tm_imageButtons) {
     temp.setVisible(true); 
  }
  for (GTextField temp : tm_textFields) {
     temp.setVisible(true);
  }
  tmc_paceAssist.setVisible(true);
}

public void showFootballMP() {
   for (GLabel temp : fm_labels) {
      temp.setVisible(true);
   }
  for (GImageButton temp : fm_imageButtons) {
     temp.setVisible(true);
  }
   for (GTextField temp : fm_textFields) {
     temp.setVisible(true);
  }  
   for (GButton temp : fm_Buttons) {
     temp.setVisible(true);     
  }  
  fmd_choosePosition.setVisible(true);
}


public void trackAddPlayer(int currentPlayer) {
  if (!running) {
    removeAll();
    if (currentPlayer < rowHeight.length) {
      tmb_addPerson.moveTo(720, rowHeight[currentPlayer]-2);
      tmb_removePerson.moveTo(760, rowHeight[currentPlayer]-2);
    } 
    switch (currentPlayer){
      case 1:
        tm_buttons.addAll(Arrays.asList(tmb_zero2, tmb_removePerson));
        tm_imageButtons.addAll(Arrays.asList(tmb_adjustU2, tmb_adjustD2));
        tm_textFields.add(tmt_desiredLT2);
        tm_labels.addAll(Arrays.asList(tml_lapR2));
        tmt_desiredLT2.setFocus(true);
        break;
      case 2:
        tm_buttons.addAll(Arrays.asList(tmb_zero3));
        tm_imageButtons.addAll(Arrays.asList(tmb_adjustU3, tmb_adjustD3));
        tm_textFields.addAll(Arrays.asList(tmt_desiredLT3));
        tm_labels.addAll(Arrays.asList(tml_lapR3));
        tmt_desiredLT3.setFocus(true);
        break;
      case 3:
        tm_buttons.addAll(Arrays.asList(tmb_zero4));
        tm_imageButtons.addAll(Arrays.asList(tmb_adjustU4, tmb_adjustD4));
        tm_textFields.addAll(Arrays.asList(tmt_desiredLT4));
        tm_labels.addAll(Arrays.asList(tml_lapR4));
        tm_buttons.remove(tmb_addPerson);
        tmt_desiredLT4.setFocus(true);
        break;
    }
    showTrackMP();
  }
}

public void trackRemovePlayer(int currentPlayer) {
  if (!running) {
    removeAll();
    if (currentPlayer > 1) {
       tmb_addPerson.moveTo(720, rowHeight[currentPlayer-2]-2);
       tmb_removePerson.moveTo(760, rowHeight[currentPlayer-2]-2); 
    }
    switch (currentPlayer) {
      case 2:
        tm_buttons.removeAll(Arrays.asList(tmb_zero2, tmb_removePerson));
        tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU2, tmb_adjustD2));
        tm_textFields.remove(tmt_desiredLT2);
        tm_labels.removeAll(Arrays.asList(tml_lapR2));
        break;
      case 3:
        tm_buttons.removeAll(Arrays.asList(tmb_zero3));
        tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU3, tmb_adjustD3));
        tm_textFields.remove(tmt_desiredLT3);
        tm_labels.removeAll(Arrays.asList(tml_lapR3));
        break;
      case 4:
        tm_buttons.add(tmb_addPerson);
        tm_buttons.removeAll(Arrays.asList(tmb_zero4));
        tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU4, tmb_adjustD4));
        tm_labels.removeAll(Arrays.asList(tml_lapR4));
        tm_textFields.remove(tmt_desiredLT4);
        break;
    }
    showTrackMP();
    tmt_desiredTimes[currentPlayer-1].setText("0");
  }  
}

public void showTP() {
   for (GLabel temp : t_labels) {
      temp.setVisible(true);
   } 
   for (GButton temp : t_buttons) {
      temp.setVisible(true); 
   }
}
