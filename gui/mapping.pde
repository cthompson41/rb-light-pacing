/*
  mapping.pde
  Contains global variables for mapping player position to the actual LED strip
  
  Called in updatevariables (redbull.pde) after all timing/position for each runner is determined. 
  
  This reinitializes the variables used to determine the physical led location for the runner positions to the values
  determined in the logic. The base logic for this was from NI/Redbull and didn't change much, so it isn't commented well
  All that was added was the arrays instead of single variables to account for multiple runners
*/

boolean[] reversed;
int[] controller;
int[] strip;
long[] pixelInStrip;


public void determinePixel(){
    if (fml_title.isVisible()){
    numPlayers = 1;
    }
  
    reversed = new boolean[numPlayers];
    controller = new int[numPlayers];
    strip = new int[numPlayers];
    pixelInStrip = new long[numPlayers];
    for (int i=0; i<numPlayers; i++) {
      controller[i] = -1;
      strip[i] = -1;
      pixelInStrip[i] = -1;
      reversed[i] = false;
    }
    for (int i=0; i<numPlayers; i++) {
      long positionPixels = pixelPositions[i];
      if(positionPixels>=0 && positionPixels<=239){
        reversed[i]=true;
        strip[i]=0;
        controller[i]=1;
        pixelInStrip[i]=240-positionPixels;
      }
      if(positionPixels>=240 && positionPixels<=479){
        reversed[i]=true;
        strip[i]=1;
        controller[i]=1;
        pixelInStrip[i]=480-positionPixels;
      }
      if(positionPixels>=480 && positionPixels<=719){
        reversed[i]=true;
        strip[i]=2;
        controller[i]=1;
        pixelInStrip[i]=720-positionPixels;
      }
      if(positionPixels>=720 && positionPixels<=959){
        reversed[i]=false;
        strip[i]=3;
        controller[i]=1;
        pixelInStrip[i]=positionPixels-720;
      }
      if(positionPixels>=960 && positionPixels<=1199){
        reversed[i]=false;
        strip[i]=4;
        controller[i]=1;
        pixelInStrip[i]=positionPixels-960;
      }
      if(positionPixels>=1200 && positionPixels<=1439){
        reversed[i]=false;
        strip[i]=5;
        controller[i]=1;
        pixelInStrip[i]=positionPixels-1200;
      }    
      if(positionPixels>=6000 && positionPixels<=6239){
        reversed[i]=true;
        strip[i]=0;
        controller[i]=2;
        pixelInStrip[i]=6240-positionPixels;
      }
      if(positionPixels>=6240 && positionPixels<=6479){
        reversed[i]=true;
        strip[i]=1;
        controller[i]=2;
        pixelInStrip[i]=6480-positionPixels;
      }
      if(positionPixels>=6480 && positionPixels<=6719){
        reversed[i]=true;
        strip[i]=2;
        controller[i]=2;
        pixelInStrip[i]=6720-positionPixels;
      }
      if(positionPixels>=6720 && positionPixels<=6959){
        reversed[i]=false;
        strip[i]=3;
        controller[i]=2;
        pixelInStrip[i]=positionPixels-6720;
      }
      if(positionPixels>=6960 && positionPixels<=7199){
        reversed[i]=false;
        strip[i]=4;
        controller[i]=2;
        pixelInStrip[i]=positionPixels-6960;
      }
      if(positionPixels>=7200 && positionPixels<=7439){
        reversed[i]=false;
        strip[i]=5;
        controller[i]=2;
        pixelInStrip[i]=positionPixels-7200;
      }
    }    
  } 

