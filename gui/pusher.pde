/*
  pusher.pde
  This writes the LED commands and lights the physical LEDs
*/

//Global variable shortcut to avoid having to change the return from lightuppixels
int chosenPlayer = -1;
int stripCount = 6;

//Don't know about initial part of code
//Iterates through each strip connected to the pixelpusher controller. For each pixel location in each strip, if the
//pixel should be lit (Determined by comparing to variables set in mapping.pde), sets the pixel to the pulse color for that 
//runner (the chosenPlayer variable). Otherwise, sets the pixel to the strip color (no light).
public void writeToPixels(){
  if (testObserver.hasStrips) {
    registry.startPushing();
     Map<String, PixelPusher> controllerMap = registry.getPusherMap();
      
      for (Map.Entry ppMappedController : controllerMap.entrySet()) {
        chosenPlayer=-1;
        PixelPusher ppController = (PixelPusher) ppMappedController.getValue();
        List<Strip> strips = ppController.getStrips();
        int intControllerNo = ppController.getControllerOrdinal();
        int stripNo = 0;
        for(Strip pstrip : strips) {
          color stripColor = #000000;
          
          for (int stripx = 0; stripx < pstrip.getLength(); stripx++) {
            //If strip matches one that should be lit and 
            //it's not true that pace assist is enabled and the light should not be lit because of pace assist lap count
            //ligtht led with player color. Otherwise, light led with strip color
            if(lightUpPixel(intControllerNo, stripNo, stripx) && !(tmc_paceAssist.isSelected() && isPaceAssistLightingStop(chosenPlayer, stripNo))) {
              pstrip.setPixel(pulseColor[chosenPlayer], stripx);
            } else {
              pstrip.setPixel(stripColor, stripx);
            }
          }
          stripNo++;
        }
      }
  }
}

//Called by writeToPixels to determine if the strip position should be lit
//Takes the controller, strip, and position as inputs, returns true if the three match to a point
//set in mapping.pde that says that location should be lit
//Also, iterates through each active runner to determine this. If the position matches true, it sets chosenPlayer to that runner (0-3)
//so the pulse color of that runner can be used for that location in writeToPixels.
boolean lightUpPixel(int controllerNo, int stripNo, int stripx) {
  // controller == the controller we currently need lit up
  // strip  == the strip the cursor is currently on
  // pixelInStrip == the position of the the cursor within that strip
  // reversed == whether that strip is reversed or not.
  
  if (fml_title.isVisible()){
    numPlayers = 1;
  }
  
  for (int i=0; i<numPlayers; i++) {
    //match[i] = false;                  //reset to false
    if (controllerNo != controller[i]) {
       continue; 
    }
    
    if (stripNo == strip[i]) {
      if (pixelInStrip[i] == stripx) {
        chosenPlayer=i;
        return true;
      }
      if (abs(stripx - pixelInStrip[i]) < 8) {
        chosenPlayer=i;
        return true; 
      }
      if (reversed[i]) {
        if (pixelInStrip[i] < 8) {
          if (stripNo == strip[i] + 1) {
             if (stripx > ((240-8) - pixelInStrip[i])) {
                chosenPlayer=i;
                return true;
             } 
          }
        }
      } else {
          if (pixelInStrip[i] > (240-8)) {
            if (stripNo == strip[i] + 1) {
               if (stripx > (pixelInStrip[i]-240)) {
                  chosenPlayer=i;
                  return true;
               } 
            }
          }
      }
    }
  }
  return false;
}

