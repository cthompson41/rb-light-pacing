int chosenPlayer = -1;

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
            if(lightUpPixel(intControllerNo, stripNo, stripx)) {
              println("HERE: " + System.nanoTime());
              pstrip.setPixel(pulseColor[chosenPlayer], stripx);
            }
            else{
              pstrip.setPixel(stripColor, stripx);
            }
          }
         
          stripNo++;
        }
      }
  }
}

boolean lightUpPixel(int controllerNo, int stripNo, int stripx) {
  // controller == the controller we currently need lit up
  // strip  == the strip the cursor is currently on
  // pixelInStrip == the position of the the cursor within that strip
  // reversed == whether that strip is reversed or not.
  for (int i=0; i<numPlayers; i++) {
    if (controllerNo != controller[i]) {
       return false; 
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

// intControllerNo==controller && stripNo==strip && (abs(stripx-pixelInStrip)<8)){

