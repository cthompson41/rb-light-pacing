/*
  Redbull.pde
  Sets up most global variables for calculating position on track, contains methods for gui (setup, draw) and to update variables (called in rapid succession when running)
*/

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

//=============================================================================================================
//Global Variables for tracking position and showing on LEDs
float trackLength;
int ledHeight = 6;                                                    //height of button representing virtual led
double[] targetTime;                                                  //array for each runner
boolean[] match; 
double position=0;
boolean[] toClear;
double[] lastPositions;                                               //array for each runner
double[] lastTimes;                                                   //array for each runner
int[] lapCounter;                                                     //array for each runner
boolean[] stillRunning;                                               //array for each runner
long startTime;
float startPosition;
double velocity;
color[] pulseColor=new color[]{#FF0000, #00FF00, #0000FF, #FFFF00};   //if you change this, change the led[0:3] colors in gui.pde
boolean running=false;                                                //set to true when running, false when not or finished
//long positionPixels=0;
long[] pixelPositions;                                                //array for each runner
double computedSpeedIncrease = 0;
boolean hysteresis = false;
double elapsed_seconds = 0;
float pi = (float) Math.PI;
int football_led_height = 12;

int numPlayers;                                                       //Used in most loops to determine how many times to run through logic
int frameWidth = 1020;
int frameHeight = 637;

/*
  Called rapidly, executes if running==true. If tml_title is visible then we are in track page. If football, then football page. Each runs its own set of logic
  Iterates through all arrays that exist for all runners and calculates time elapsed. This is used with the calculated velocity of that runner to determine the
  runners new position. If the new position modded with the track length is smaller than the old position, a lap was finished, so run that logic. Otherwise, just 
  update the position of that runner. If a runner is complete, hide that runner, then see if other runners are still running. If not, then set running=false to kill 
  loop
*/
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
          //println("elapsed: " + elapsed_seconds + "    velocity: " + velocity + "    position: "+ position);
          if (position < lastPositions[i]) { //finished a lap, set hysteresis to true
            hysteresis = true;
          }
          if (toClear[i]) {
            lastPositions[i] = 0; 
          } else {
            lastPositions[i] = position;
          }
          if (hysteresis) {  //finished a lap, change lap counter, break if done
            lapCounter[i]--;
            tm_lapR[i].setText("" + lapCounter[i]);
            if (lapCounter[i]==0) {  //done running, hide current runner light, see if all runners done running
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
          pixelPositions[i] = (long)(position * 12000/trackLength);     //for pixelpusher led strip
                                                                         //was just *48, but added *250/trackLength to change position if track length adjusted from 250
        }
      } //end for loop to iterate through all players
      moveLED(led, targetTime);  //moveLED lights (virtual lights) for all players
      determinePixel();          //light actual led lights for all players
      
      
     }
     else if (fml_title.isVisible()){
       moveFootballLED(football_led, targetTime);    
     }
   }
}

public void setup(){
  size(frameWidth, frameHeight, JAVA2D);    //frameWidth and frameHeight must match GUI background image pixel counts
  createGUI();
  frameRate(60);
  // Place your setup code here
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
}

public void draw(){
  background(backgroundImage);    //set background to redbull bg image
  rectMode(CENTER);
  updateVariables();              //call updatevariables is safe b/c running=false
  writeToPixels();                //call to light actual LED strips
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}

