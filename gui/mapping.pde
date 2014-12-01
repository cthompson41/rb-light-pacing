boolean[] reversed;
int[] controller;
int[] strip;
long[] pixelInStrip;

public void determinePixel(){
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

