// Need G4P library
import g4p_controls.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import com.heroicrobot.dropbit.devices.pixelpusher.PixelPusher;

import processing.core.*;
import java.util.*;
import java.text.*;

DeviceRegistry registry;

TestObserver testObserver;

//global variables
int lapCounter=0;
float trackLength = 250;
double targetTime=5; //KEEP
double increaseSpeed=5.0;
double position=0;
long startTime;
float startPosition;
double velocity;
color pulseColor=#FA150D;
boolean running=false;
long positionPixels=0;
double percentBump=.05;
double computedSpeedIncrease = 0;
boolean hysteresis = false;
double lastPosition = 250.0;
double elapsed_seconds = 0;




int frameWidth = 1020;
int frameHeight = 637;

synchronized public void updateVariables(){
    if(running){
    long currentTime = System.nanoTime();
    long elapsed = currentTime-startTime;
    elapsed_seconds = elapsed/1000000000.0;
    velocity=(250.0/targetTime)*(1.0+computedSpeedIncrease/100.0);
    position = (velocity*elapsed_seconds) % 250.0;//position in meters
    moveLED(led1);        
 }
}

public void setup(){
  size(frameWidth, frameHeight, JAVA2D);
  createGUI();
  frameRate(60);
  // Place your setup code here
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  
}

public void draw(){
  background(backgroundImage);
  fill(pulseColor);
  rectMode(CENTER);
  updateVariables();
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}

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
  paceAssist.setVisible(false);
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
  paceAssist.setVisible(true);
}

public void trackAddPlayer(int currentPlayer) {
  removeAll();
  if (currentPlayer < rowHeight.length) {
    tmb_addPerson.moveTo(920, rowHeight[currentPlayer]-2);
    tmb_removePerson.moveTo(960, rowHeight[currentPlayer]-2);
  } 
  switch (currentPlayer){
    case 1:
      tm_buttons.addAll(Arrays.asList(tmb_zero2, tmb_removePerson));
      tm_imageButtons.addAll(Arrays.asList(tmb_adjustU2, tmb_adjustD2));
      tm_textFields.add(tmt_desiredLT2);
      break;
    case 2:
      tm_buttons.addAll(Arrays.asList(tmb_zero3));
      tm_imageButtons.addAll(Arrays.asList(tmb_adjustU3, tmb_adjustD3));
      tm_textFields.addAll(Arrays.asList(tmt_desiredLT3));
      break;
    case 3:
      tm_buttons.addAll(Arrays.asList(tmb_zero4));
      tm_imageButtons.addAll(Arrays.asList(tmb_adjustU4, tmb_adjustD4));
      tm_textFields.addAll(Arrays.asList(tmt_desiredLT4));
      tm_buttons.remove(tmb_addPerson);
      break;
  }
  showTrackMP();
}

public void trackRemovePlayer(int currentPlayer) {
  removeAll();
  if (currentPlayer > 1) {
     tmb_addPerson.moveTo(920, rowHeight[currentPlayer-2]-2);
     tmb_removePerson.moveTo(960, rowHeight[currentPlayer-2]-2); 
  }
  switch (currentPlayer) {
    case 2:
      tm_buttons.removeAll(Arrays.asList(tmb_zero2, tmb_removePerson));
      tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU2, tmb_adjustD2));
      tm_textFields.remove(tmt_desiredLT2);
      break;
    case 3:
      tm_buttons.removeAll(Arrays.asList(tmb_zero3));
      tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU3, tmb_adjustD3));
      tm_textFields.remove(tmt_desiredLT3);
      break;
    case 4:
      tm_buttons.add(tmb_addPerson);
      tm_buttons.removeAll(Arrays.asList(tmb_zero4));
      tm_imageButtons.removeAll(Arrays.asList(tmb_adjustU4, tmb_adjustD4));
      tm_textFields.remove(tmt_desiredLT4);
      break;
  }
  showTrackMP();
}

public void showTP() {
   for (GLabel temp : t_labels) {
      temp.setVisible(true);
   } 
   for (GButton temp : t_buttons) {
      temp.setVisible(true); 
   }
}
