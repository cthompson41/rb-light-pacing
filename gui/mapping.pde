boolean reversed=false;
int controller=-1;
int strip=-1;
long pixelInStrip=-1;

public void determinePixel(){
  for (int i=0; i<numPlayers; i++) {
    long positionPixels = pixelPositions[i];
    controller=-1;
    strip=-1;
    pixelInStrip=-1;
    if(positionPixels>=0 && positionPixels<=239){
      reversed=true;
      strip=0;
      controller=1;
      pixelInStrip=240-positionPixels;
    }
    if(positionPixels>=240 && positionPixels<=479){
      reversed=true;
      strip=1;
      controller=1;
      pixelInStrip=480-positionPixels;
    }
    if(positionPixels>=480 && positionPixels<=719){
      reversed=true;
      strip=2;
      controller=1;
      pixelInStrip=720-positionPixels;
    }
    if(positionPixels>=720 && positionPixels<=959){
      reversed=false;
      strip=3;
      controller=1;
      pixelInStrip=positionPixels-720;
    }
    if(positionPixels>=960 && positionPixels<=1199){
      reversed=false;
      strip=4;
      controller=1;
      pixelInStrip=positionPixels-960;
    }
    if(positionPixels>=1200 && positionPixels<=1439){
      reversed=false;
      strip=5;
      controller=1;
      pixelInStrip=positionPixels-1200;
    }    
    if(positionPixels>=6000 && positionPixels<=6239){
      reversed=true;
      strip=0;
      controller=2;
      pixelInStrip=6240-positionPixels;
    }
    if(positionPixels>=6240 && positionPixels<=6479){
      reversed=true;
      strip=1;
      controller=2;
      pixelInStrip=6480-positionPixels;
    }
    if(positionPixels>=6480 && positionPixels<=6719){
      reversed=true;
      strip=2;
      controller=2;
      pixelInStrip=6720-positionPixels;
    }
    if(positionPixels>=6720 && positionPixels<=6959){
      reversed=false;
      strip=3;
      controller=2;
      pixelInStrip=positionPixels-6720;
    }
    if(positionPixels>=6960 && positionPixels<=7199){
      reversed=false;
      strip=4;
      controller=2;
      pixelInStrip=positionPixels-6960;
    }
    if(positionPixels>=7200 && positionPixels<=7439){
      reversed=false;
      strip=5;
      controller=2;
      pixelInStrip=positionPixels-7200;
    }
  }    
}

