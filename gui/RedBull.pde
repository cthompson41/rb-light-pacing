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

float trackLength;
double[] targetTime; 
double increaseSpeed=5.0;
double position=0;
double[] lastPositions;
double[] lastTimes;
int[] lapCounter;
boolean[] stillRunning;
long startTime;
float startPosition;
double velocity;
color pulseColor=#FA150D;
boolean running=false;
//long positionPixels=0;
long[] pixelPositions;
double percentBump=.05;
double computedSpeedIncrease = 0;
boolean hysteresis = false;
double elapsed_seconds = 0;
float pi = (float) Math.PI;
int football_led_height = 12;

int numPlayers;
int frameWidth = 1020;
int frameHeight = 637;

synchronized public void updateVariables(){
  if(running){
    if (tml_title.isVisible()){
      for (int i=0; i<numPlayers; i++) {
        if (stillRunning[i]) {
          hysteresis = false;
          long currentTime = System.nanoTime();
          long elapsed = currentTime-(long)lastTimes[i];
          lastTimes[i] = currentTime;
          elapsed_seconds = elapsed/1000000000.0;
          velocity=trackLength/targetTime[i];
          position = (lastPositions[i] + (velocity*elapsed_seconds)) % trackLength;//position in meters
          println("elapsed: " + elapsed_seconds + "    velocity: " + velocity + "    position: "+ position);
          if (position < lastPositions[i]) { //finished a lap, set hysteresis to true
            hysteresis = true;
          }
          lastPositions[i] = position;
          if (hysteresis) {  //finished a lap, change lap counter, break if done
            lapCounter[i]--;
            tm_lapR[i].setText("" + lapCounter[i]);
            if (lapCounter[i]==0) {  //done running, see if all done running
              led[i].setAlpha(0);    //done running this current, so hide it
              stillRunning[i] = false;
              running = false;       //check if others have laps remaining. If so, set running back to true
              for (int temp=0; temp<numPlayers; temp++) {
                if (lapCounter[temp]!=0) {
                  running = true;
                } 
              }
            }  
          }
          pixelPositions[i] = (long)(position * 48);
        }
        
        //Pixelpusher side
        //positionPixels = (long)(position * 48);//position in pixels in a lap

      }
      moveLED(led, targetTime);
      determinePixel();
      
      
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
  writeToPixels();
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}

