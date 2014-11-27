//Ordered table of contents for helper functions
//1. Helper functions for logic
//2. Helper functions for drawing controls
//3. Helper functions for showing/hiding controls 

//=============================================================================================================
//1. Helper functions for logic
private int getPlayerCount() {
  int count = 0;
  for (GTextField temp : tmt_desiredTimes) {
    if (temp.getText().length() != 0) {
      if (Double.parseDouble(temp.getText()) != 0) {
        count++;
      }
    } else {
      break;
    } 
  }
  return count;
}

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
    //if tmt_totalNOL is empty or if it is non-numeric, "Please enter a numeric value 1-20 in total number of laps"
    if (tmt_totalNOL.getText().length() == 0) {
        throw new Exception("Please enter a numeric value 1-20 in total number of laps");
    } else {
      double numLaps = Double.parseDouble(tmt_totalNOL.getText());
      if (numLaps < 0 || numLaps > 20) {
         throw new Exception("Please enter a numeric value 1-20 in total number of laps");
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
  } catch (NumberFormatException e) {
    //Error in parsing some input field as a double
    println("Error in verifyCTIInput: Please verify only numerical entries are given in all text boxes");
    
  } catch (Exception e) {
    //Custom exception thrown, pring error message
    println("Error in verifyCTIInput: " + e.toString());
  }
  return false; 
}

private void updateRunnerSpeeds() {
    for (int temp=0; temp<numPlayers; temp++) {
      targetTime[temp] = Double.parseDouble(tmt_desiredTimes[temp].getText());
    }
}


private void adjustTime(int player, String direction) {
  GTextField thisLT = tmt_desiredTimes[player-1];
  double time;
  try {
    time = Double.parseDouble(thisLT.getText());
  } 
  catch (NumberFormatException e) {
    println("Valid number not in desired lap time for player " + player + ". Resetting lap time to 0.");
    time = 0;
  }
  if (direction == "UP") {
    time += 0.1;
  } else {
    time -= 0.1;
    //must check if time below zero after subtraction. Cannot check if time == 0.1 b/c of double math
    if (time < .1000001) {
      time = .1;
    }
  }
  thisLT.setText(String.format("%.2f", time));
}

private int findPlayerNumber(float y){
  //find player number for which add/removePerson was clicked
  //returns player index if player found, -1 otherwise
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
}


public void trackAddPlayer(int currentPlayer) {
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
      break;
    case 2:
      tm_buttons.addAll(Arrays.asList(tmb_zero3));
      tm_imageButtons.addAll(Arrays.asList(tmb_adjustU3, tmb_adjustD3));
      tm_textFields.addAll(Arrays.asList(tmt_desiredLT3));
      tm_labels.addAll(Arrays.asList(tml_lapR3));
      break;
    case 3:
      tm_buttons.addAll(Arrays.asList(tmb_zero4));
      tm_imageButtons.addAll(Arrays.asList(tmb_adjustU4, tmb_adjustD4));
      tm_textFields.addAll(Arrays.asList(tmt_desiredLT4));
      tm_labels.addAll(Arrays.asList(tml_lapR4));
      tm_buttons.remove(tmb_addPerson);
      break;
  }
  showTrackMP();
  tmt_desiredTimes[currentPlayer].setText("5");
}

public void trackRemovePlayer(int currentPlayer) {
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

public void showTP() {
   for (GLabel temp : t_labels) {
      temp.setVisible(true);
   } 
   for (GButton temp : t_buttons) {
      temp.setVisible(true); 
   }
}
