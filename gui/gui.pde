/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */
 
import java.awt.Font;
//TESTING TESTING 123456 Chris has a big dick

//public void targetTime_textBox_change1(GTextField source, GEvent event) { //_CODE_:targetTime_textBox:707084:
//  println("textfield1 - GTextField event occured " + System.currentTimeMillis()%10000000 );
//  targetTime=Double.parseDouble(source.getText());
//} //_CODE_:targetTime_textBox:707084:

public void tmb_start_click(GButton source, GEvent event) { //_CODE_:startButton:595488:
  println("button1 - GButton event occured " + System.currentTimeMillis()%10000000 );
  running=true;
  startTime = System.nanoTime();
  startPosition = led1.getX();
  led1.setAlpha(255);
  updateVariables();
} //_CODE_:startButton:595488:

//public void stopButton_click1(GButton source, GEvent event) { //_CODE_:stopButton:371419:
//  println("stopButton - GButton event occured " + System.currentTimeMillis()%10000000 );
//  running=false;
////  updateVariables();
//  println("Stopping.  Laps remaining == "+lapCounter+" speed increase == "+ computedSpeedIncrease +"%"
//              + " velocity == "+velocity+ " m/s");
//} //_CODE_:stopButton:371419:

public void titlePaigeButton_click(GButton source, GEvent event) {
  println("titlePaigeButton - GButton event occured" + System.currentTimeMillis()%10000000);
  removeAll();
  showTP();
}

public void tb_track_click(GButton source, GEvent event) {
   println("tb_track click - GButton event occured" + System.currentTimeMillis()%10000000);
   removeAll();
   showTrackMP(); 
}

public void tb_football_click(GButton source, GEvent event) {
   println("tb_football click - GButton event occured" + System.currentTimeMillis()%10000000);
   removeAll();
   showFootballTP();  
}

public void cb_click(GButton source, GEvent event) {
   println("cb_click (" + source.getText() + ") - GButton event occured" + System.currentTimeMillis()%1000000);
   removeAll();
   showTrackMP();
}

public void moveLED(GButton light){
  float p =(float) position;
  float ledTrackLength = (track.getWidth()-track.getHeight())*2+3.14159*track.getHeight();
  float ledPosition = p/trackLength*ledTrackLength;
  
//  if (led.getX()<track.getX()+track.getWidth()-track.getHeight()/2) {
  if (ledPosition<track.getWidth()-track.getHeight()) {
  light.moveTo(startPosition+ledPosition,track.getY()+track.getHeight());
  }
  else if (track.getWidth()-track.getHeight()<ledPosition && ledPosition<track.getWidth()-track.getHeight()+track.getHeight()*3.14159/4) {
   float s = (ledPosition - (track.getWidth()-track.getHeight()));
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
   float centerPointY1 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX1+cos(theta)*track.getHeight()/2,centerPointY1-sin(theta)*track.getHeight()/2); 
  }
  else if (ledPosition>track.getWidth()-track.getHeight()+track.getHeight()*3.14159/4 && ledPosition<track.getWidth()-track.getHeight()+track.getHeight()*3.14159/2) {
   float s = (ledPosition - (track.getWidth()-track.getHeight()));
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX1 = track.getX()+track.getWidth()-track.getHeight()/2;
   float centerPointY1 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX1+cos(theta)*track.getHeight()/2,centerPointY1-sin(theta)*track.getHeight()/2-light.getHeight()); 
  }
   else if (ledPosition>track.getWidth()-track.getHeight()+track.getHeight()*3.14159/2 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2) {
    light.moveTo(startPosition+((track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2)-ledPosition,light.getY());
  }
   else if (ledPosition>(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159/2 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159*3/4) {
   float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*3.14159/2);
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX2 = track.getX()+track.getHeight()/2;
   float centerPointY2 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light.getWidth(),centerPointY2+sin(theta)*track.getHeight()/2-light.getHeight()); 
  }
   else if (ledPosition>(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159*3/4 && ledPosition<(track.getWidth()-track.getHeight())*2+track.getHeight()*3.14159) {
   float s = (ledPosition - (track.getWidth()-track.getHeight())*2 - track.getHeight()*3.14159/2);
   float theta = s/(track.getHeight()/2)+3.14159*3/2;
   float centerPointX2 = track.getX()+track.getHeight()/2;
   float centerPointY2 = track.getY()+track.getHeight()/2;
   light.moveTo(centerPointX2-cos(theta)*track.getHeight()/2-light.getWidth(),centerPointY2+sin(theta)*track.getHeight()/2); 
   }
}
public void tmb_addPerson_click(GButton source, GEvent event) {
  //find which player was added
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
   throw new Error("Error in addPlayer -> player not found"); 
  }
  println("tmb_addPerson_click - GButton event occured: player " + player + " clicked");
  trackAddPlayer(player);
}

public void tmb_removePerson_click(GButton source, GEvent event) {
  //find which player was removed
  int player = findPlayerNumber(source.getY());
  //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
   throw new Error("Error in removePlayer -> player not found"); 
  }
  println("tmb_removePerson_click - GButton event occured: player " + player + " clicked");
  trackRemovePlayer(player);
}

public void tmb_adjustU_click(GImageButton source, GEvent event) {
  //find which player is adjusted
  println("test123");
 int player = findPlayerNumber(source.getY());
 //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
   throw new Error("Error in adjust_click -> player not found"); 
  }
  println("tmb_adjustU_click - GButton event occured: player " + player + " clicked");
  adjustTime(player, "UP");
}

private void adjustTime(int player, String direction) {
  GTextField thisLT = tmt_desiredTimes[player-1];
  double time;
  try {
    time = Double.parseDouble(thisLT.getText());
  } catch (NumberFormatException e) {
    println("Valid number not in desired lap time for player " + player + ". Resetting lap time to 0.");
    time = 0; 
  }
  if (direction == "UP") {
    time += 0.1;
  } else {
    time -= 0.1;
    //must check if time below zero after subtraction. Cannot check if time == 0.1 b/c of double math
    if (time < 0) {
      time = 0;
    }
  }
  thisLT.setText(String.format("%.2f", time));
}

public void tmb_adjustD_click(GImageButton source, GEvent event) {
  //find which player is adjusted
 int player = findPlayerNumber(source.getY());
 //sanity check - if player is larger than rowHeight, the location of the sourcebutton doesn't match one of the rowheights, throw error
  if (player == -1) {
   throw new Error("Error in adjust_click -> player not found"); 
  }
  println("tmb_adjustD_click - GButton event occured: player " + player + " clicked");
  adjustTime(player, "DOWN");
}

private int findPlayerNumber(float y){
  //find player number for which add/removePerson was clicked
  //returns player index if player found, -1 otherwise
  int player = 1;
  for (int temp : rowHeight) {
    if (temp == y + 2) {
      break;
    } else {
      player++;
    }
  }
  //return -1 if not found
  if (player > rowHeight.length) {
     player = -1; 
  }
  return player;
}

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  //General Setup
  backgroundImage = loadImage("background.jpg");
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.RED_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("Red Bull Light Trainer");
  titlePaigeButton = new GButton(this, 940, 0, 80, 40);
  titlePaigeButton.setText("Title Page");
  titlePaigeButton.addEventHandler(this, "titlePaigeButton_click");
  //=============================================================================================================     
  //Title Page Setup
  tl_title = makeTitle(0, 25, frameWidth, 300, 100, tl_title, "LIGHT PACING DEVICE", true);
  tb_track = makeButton(frameWidth/2 - 300, 350, 200, 60, tb_track, "Track", true, "tb_track_click");
  tb_football = makeButton(frameWidth/2 + 100, 350, 200, 60, tb_football, "Football", true, "tb_football_click");
  //Title Page Containers 
  t_labels = new ArrayList<GLabel>();
  t_labels.add(tl_title);
  t_buttons = new ArrayList<GButton>(Arrays.asList(tb_track, tb_football));
  //=============================================================================================================
  //Football Title Page Setup
  ftl_title = makeTitle(0, 0, frameWidth, 200, 100, ftl_title, "FOOTBALL", false);
  ftb_dash = makeButton(200, 300, 250, 90, ftb_dash, "Forty Yard Dash", false, "");
  ftb_fivetenfive = makeButton(550, 300, 250, 90, ftb_fivetenfive, "5-10-5", false, "");
  //Football Title Page Containers
  ft_labels = new ArrayList<GLabel>();
  ft_labels.add(ftl_title);
  ft_buttons = new ArrayList<GButton>(Arrays.asList(ftb_dash, ftb_fivetenfive));
  //=============================================================================================================
  //Track Main Page
  rowHeight = new int[]{90, 122, 154, 186}; //for runner rows, used in add/remove person
  tml_title = makeTitle(0, 0, frameWidth, 50, 40, tml_title, "Track", false);
  tml_desiredLT = makeTitle(100, 50, 250, 40, 20, tml_desiredLT, "Desired Lap Time", false);
  tml_adjustP = makeTitle(frameWidth/2-125, 50, 250, 40, 20, tml_adjustP, "Adjust Pace", false);
  tml_zero = makeTitle((frameWidth/2-125)*2-100, 50,250, 40, 20, tml_zero, "Zero", false); 
  tml_totalNOL = makeTitle(78, 270, 200, 40, 20, tml_totalNOL, "Number of Laps", false);
  tml_remainingNOL = makeTitle(320, 480, 250, 80, 25, tml_remainingNOL, "Lap Number", false);
  tml_paceT = makeTitle(120, 241, 150, 40, 20, tml_paceT, "Pace Assist", false);
  tmt_totalNOL = makeTextField(270, 281, 40, 20, 20, tmt_totalNOL, "", false, "");
  //Each number is for the that number runner. The items are on rows per player, with a height of 10 between rows
  int desiredLTX = (int) tml_desiredLT.getX();
  tmt_desiredLT1 = makeTextField(desiredLTX, rowHeight[0], 250, 22, 18, tmt_desiredLT1, "", false, "");
  tmt_desiredLT2 = makeTextField(desiredLTX, rowHeight[1], 250, 22, 18, tmt_desiredLT2, "", false, "");
  tmt_desiredLT3 = makeTextField(desiredLTX, rowHeight[2], 250, 22, 18, tmt_desiredLT3, "", false, "");
  tmt_desiredLT4 = makeTextField(desiredLTX, rowHeight[3], 250, 22, 18, tmt_desiredLT4, "", false, "");
  
  track = makeImageButton(520, 250, 301, 140, track, false, "track_click", "track3.png");
  tmb_adjustU1 = makeImageButton(frameWidth/2-5-25, rowHeight[0]-2, 25, 25, tmb_adjustU1, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU2 = makeImageButton(frameWidth/2-5-25, rowHeight[1]-2, 25, 25, tmb_adjustU2, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU3 = makeImageButton(frameWidth/2-5-25, rowHeight[2]-2, 25, 25, tmb_adjustU3, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU4 = makeImageButton(frameWidth/2-5-25, rowHeight[3]-2, 25, 25, tmb_adjustU4, false, "tmb_adjustU_click", "up.png");
  tmb_adjustD1 = makeImageButton(frameWidth/2+5, rowHeight[0]-2, 25, 25, tmb_adjustD1, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD2 = makeImageButton(frameWidth/2+5, rowHeight[1]-2, 25, 25, tmb_adjustD2, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD3 = makeImageButton(frameWidth/2+5, rowHeight[2]-2, 25, 25, tmb_adjustD3, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD4 = makeImageButton(frameWidth/2+5, rowHeight[3]-2, 25, 25, tmb_adjustD4, false, "tmb_adjustD_click", "down.png");
  tmb_zero1 = makeButton((frameWidth/2-125)*2-100+62, rowHeight[0]-2, 125, 25, tmb_zero1, "", false, "");
  tmb_zero2 = makeButton((frameWidth/2-125)*2-100+62, rowHeight[1]-2, 125, 25, tmb_zero2, "", false, "");
  tmb_zero3 = makeButton((frameWidth/2-125)*2-100+62, rowHeight[2]-2, 125, 25, tmb_zero3, "", false, "");
  tmb_zero4 = makeButton((frameWidth/2-125)*2-100+62, rowHeight[3]-3, 125, 25, tmb_zero4, "", false, "");
  tmb_addPerson = makeButton(920, rowHeight[0]-2, 25, 25, tmb_addPerson, "+", false, "tmb_addPerson_click");
  tmb_removePerson = makeButton(960, rowHeight[1]-2, 25, 25, tmb_removePerson, "-", false, "tmb_removePerson_click");
  tmb_start = makeButton(140, 500, 150, 50, tmb_start, "Start", false, "tmb_start_click");
  tmb_reset = makeButton(140, 570, 150, 50, tmb_reset, "Reset", false, "tmb_reset_click");
// tmb_paceT, tmb_start, tmb_reset;
//  GTextField tmt_desiredLT1, tmt_desiredLT2, tmt_desiredLT3, tmt_desiredLT4, tmt_totalNOL
//  GButton[] cm_adjustU, cm_adjustD, cm_zero, cm_buttons;
  tm_labels = new ArrayList<GLabel>(Arrays.asList(tml_title, tml_desiredLT, tml_adjustP, tml_zero, tml_totalNOL, tml_remainingNOL, tml_paceT));
  tm_buttons = new ArrayList<GButton>();
  tm_imageButtons = new ArrayList<GImageButton>(Arrays.asList(tmb_adjustU1, tmb_adjustD1,track));
  tm_buttons.addAll(Arrays.asList(tmb_zero1, tmb_addPerson, tmb_start, tmb_reset));
  tm_textFields = new ArrayList<GTextField>(Arrays.asList(tmt_totalNOL, tmt_desiredLT1));
  tmt_desiredTimes = new GTextField[]{tmt_desiredLT1, tmt_desiredLT2, tmt_desiredLT3, tmt_desiredLT4};
  //
  paceAssist = new GCheckbox(this, 280, 250, 25, 25);
  paceAssist.setVisible(false);
  //
  int ledHeight = 6;
  led1 = new GButton(this, track.getX()+(track.getHeight()/2), track.getY()+track.getHeight(), ledHeight, ledHeight);
  led1.setEnabled(false);
  led1.setLocalColorScheme(color(1,1,1));
  led1.setAlpha(0);
  //=============================================================================================================
  //Final: Let this be the last code before the closing bracket in order to avoid null pointers
  labels = new ArrayList<List<GLabel>>(Arrays.asList(t_labels, ft_labels, tm_labels));
  textFields = new ArrayList<List<GTextField>>(Arrays.asList(tm_textFields));
  buttons = new ArrayList<List<GButton>>(Arrays.asList(t_buttons, ft_buttons, tm_buttons));
  imageButtons = new ArrayList<List<GImageButton>>(Arrays.asList(tm_imageButtons));
}

//=============================================================================================================
public GLabel makeTitle(int p0, int p1, int p2, int p3, int fontSize, GLabel title, String text, Boolean isVisible) {
  title = new GLabel(this, p0, p1, p2, p3); 
  title.setText(text);
  title.setOpaque(false);
  title.setFont(new Font("SansSerif", Font.PLAIN, fontSize));
  title.setVisible(isVisible);
  //Make label white
  title.setLocalColorScheme(color(1,1,1));
  return title;
}

public GButton makeButton(int p0, int p1, int p2, int p3, GButton button, String text, Boolean isVisible, String eventHandler) {
  button = new GButton(this, p0, p1, p2, p3);
  button.setText(text);
  button.setFont(new Font("SansSerif", Font.PLAIN, 30));
  button.setVisible(isVisible);
  button.addEventHandler(this, eventHandler);
  return button;
}

public GImageButton makeImageButton(int p0, int p1, int p2, int p3, GImageButton button, Boolean isVisible, String eventHandler, String img) {
  String[] images = new String[1];
  images[0] = img;
  button = new GImageButton(this, p0, p1, p2, p3, images);
  button.setVisible(false);
  button.addEventHandler(this, eventHandler); 
  return button;
}

public GTextField makeTextField(int p0, int p1, int p2, int p3, int textSize, GTextField textField, String text, Boolean isVisible, String eventHandler) {
  textField = new GTextField(this, p0, p1, p2, p3);
  textField.setText(text);
  textField.setFont(new Font("SansSerif", Font.PLAIN, textSize));
  textField.setDefaultText(text);
  textField.setOpaque(true);
  textField.addEventHandler(this, eventHandler);
  textField.setVisible(isVisible);
  return textField;
}

//=============================================================================================================
// Variable declarations 
// autogenerated do not edit
GButton titlePaigeButton;
GButton led1;
//==================
//Overall Containers
List<List<GLabel>> labels;
List<List<GTextField>> textFields;
List<List<GButton>> buttons;
List<List<GImageButton>> imageButtons;
//==================
//Title Page
GLabel tl_title; 
GButton tb_track, tb_football; 
PImage backgroundImage;
List<GLabel> t_labels;
List<GButton> t_buttons;
//==================
//Track Page
int[] rowHeight;
GImageButton tmb_adjustU1, tmb_adjustU2, tmb_adjustU3, tmb_adjustU4, tmb_adjustD1, tmb_adjustD2, tmb_adjustD3, tmb_adjustD4,track;
GLabel tml_title, tml_desiredLT, tml_adjustP, tml_zero, tml_totalNOL, tml_remainingNOL, tml_paceT;
GButton tmb_zero1, tmb_zero2, tmb_zero3, tmb_zero4;
GButton tmb_addPerson, tmb_removePerson, tmb_paceT, tmb_start, tmb_reset;
GTextField tmt_desiredLT1, tmt_desiredLT2, tmt_desiredLT3, tmt_desiredLT4, tmt_totalNOL;
GTextField[] tmt_desiredTimes;
GCheckbox paceAssist;
List<GLabel> tm_labels;
List<GButton> tm_adjustU, tm_adjustD, tm_zero, tm_buttons;
List<GTextField> tm_textFields;
List<GImageButton> tm_imageButtons;
//==================
//Football Title Page
GLabel ftl_title;
GButton ftb_dash, ftb_fivetenfive;
List<GLabel> ft_labels;
List<GButton> ft_buttons;
//==================
