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
double[] targetTime; 
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
float pi = (float) Math.PI;
int football_led_height = 12;

int frameWidth = 1020;
int frameHeight = 637;

synchronized public void updateVariables(){
  if(running){
    if (tml_title.isVisible()){
      moveLED(led, targetTime);    
     }
     else if (fml_title.isVisible()){
       moveFootballLED(football_led, targetTime);    
     }
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

