public void tmb_start_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  running=true;
  if (verifyCTInput() == true) {
    int numPlayers = getPlayerCount();
    for (int temp=0; temp<numPlayers; temp++) {
       targetTimes[temp] = Double.parseDouble(tmt_desiredTimes[temp].getText());
    }
    
    startTime = System.nanoTime();
    startPosition = led1.getX();
    led1.setAlpha(255);
    led2.setAlpha(255);
    led3.setAlpha(255);
    led4.setAlpha(255);
    updateVariables();
  }
}

public void titlePaigeReturn_click(GButton source, GEvent event) {
  println("titlePaigeButton - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTP();
}

public void tb_track_click(GButton source, GEvent event) {
   println("tb_track click - GButton event occured" + System.currentTimeMillis()%10000000);
   removeAll();
   showTrackMP(); 
}

public void tb_football_click(GButton source, GEvent event) {
   println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
   removeAll();
   showFootballTP();  
}

public void cb_click(GButton source, GEvent event) {
   println("cb_click (" + source.getText() + ") - GButton event occured" + System.currentTimeMillis()%1000000);
   removeAll();
   showTrackMP();
}

public void moveLED(GButton light, double targetTime){
  long currentTime = System.nanoTime();
  long elapsed = currentTime-startTime;
  elapsed_seconds = elapsed/1000000000.0;
  velocity=(250.0/targetTime)*(1.0+computedSpeedIncrease/100.0);
  position = (velocity*elapsed_seconds) % 250.0;//position in meters
  float p =(float) position;
  float ledTrackLength = (track.getWidth()-track.getHeight())*2+3.14159*track.getHeight();
  float ledPosition = p/trackLength*ledTrackLength;
  
  if (ledPosition<track.getWidth()-track.getHeight()) {
  light.moveTo(startPosition+ledPosition,track.getY()+track.getHeight());
  }
  else if (track.getWidth()-track.getHeight()<ledPosition && ledPosition<track.getWidth()-track.getHeight()+track.getHeight()*3.14159/4) {
   float s = (ledPosition - (track.getWidth()-track.getHeight()));
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
   float centerPointY1 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX1+cos(theta)*track.getHeight()/2,centerPointY1-sin(theta)*track.getHeight()/2); 
  }
  else if (ledPosition>track.getWidth()-track.getHeight()+track.getHeight()*3.14159/4 && ledPosition<track.getWidth()-track.getHeight()+track.getHeight()*3.14159/2) {
   float s = (ledPosition - (track.getWidth()-track.getHeight()));
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
   float centerPointY1 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX1+cos(theta)*track.getHeight()/2,centerPointY1-sin(theta)*track.getHeight()/2-light.getHeight()); 
  }
   else if (ledPosition>track.getWidth()-track.getHeight()+track.getHeight()*3.14159/2 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2) {
    light.moveTo(startPosition+((track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2)-ledPosition,light.getY());
  }
   else if (ledPosition>(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159*3/4) {
   float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*3.14159/2);
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX2 = track.getX()+track.getHeight()/2;
   float centerPointY2 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light.getWidth(),centerPointY2+sin(theta)*track.getHeight()/2-light.getHeight()); 
  }
   else if (ledPosition>(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159*3/4 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159) {
   float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*3.14159/2);
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX2 = track.getX()+track.getHeight()/2;
   float centerPointY2 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light.getWidth(),centerPointY2+sin(theta)*track.getHeight()/2); 
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
  println("test123");
 int player = findPlayerNumber(source.getY());
 //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
   throw new Error("Error in adjust_click -> player not found"); 
  }
  println("tmb_adjustU_click - GButton event occured: player " + player + " clicked");
  adjustTime(player, "UP");
}

private void adjustTime(int player, String direction) {
  GTextField thisLT = tmt_desiredTimes[player-1];
  double time;
  try {
    time = Double.parseDouble(thisLT.getText());
  } catch (NumberFormatException e) {
    println("Valid number not in desired lap time for player " + player + ". Resetting lap time to 0.");
    time = 0; 
  }
  if (direction == "UP") {
    time += 0.1;
  } else {
    time -= 0.1;
    //must check if time below zero after subtraction. Cannot check if time == 0.1 b/c of double math
    if (time < 0) {
      time = 0;
    }
  }
  thisLT.setText(String.format("%.2f", time));
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
}

