public void writeToPixels(){
  if (testObserver.hasStrips) {
    registry.startPushing();
     Map<String, PixelPusher> controllerMap = registry.getPusherMap();
      
      for (Map.Entry ppMappedController : controllerMap.entrySet()) {
        PixelPusher ppController = (PixelPusher) ppMappedController.getValue();
        List<Strip> strips = ppController.getStrips();
        int intControllerNo = ppController.getControllerOrdinal();
        int stripNo = 0;
        for(Strip pstrip : strips) {
          color stripColor = #000000;
          
          for (int stripx = 0; stripx < pstrip.getLength(); stripx++) {
            if(lightUpPixel(intControllerNo, stripNo, stripx)) {
              pstrip.setPixel(pulseColor, stripx);
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
  
  if (controllerNo != controller) {
     return false; 
  }
  
  if (stripNo == strip) {
    if (pixelInStrip == stripx) {
      return true;
    }
    if (abs(stripx - pixelInStrip) < 8) {
      return true; 
    }
    if (reversed) {
      if (pixelInStrip < 8) {
        if (stripNo == strip + 1) {
           if (stripx > ((240-8) - pixelInStrip)) {
              return true;
           } 
        }
      }
    } else {
        if (pixelInStrip > (240-8)) {
          if (stripNo == strip + 1) {
             if (stripx > (pixelInStrip-240)) {
                return true;
             } 
          }
        }
    }
  }
  
  return false;
}

// intControllerNo==controller && stripNo==strip && (abs(stripx-pixelInStrip)<8)){

