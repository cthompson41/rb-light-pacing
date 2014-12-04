/* 
  GUI.pde
  Sets up all pages for GUI (title page [t_], track main page [tm_], football main page [fm_], football title page [ft_]). 
  
  All controls are made using make_____() methods in the helper.pde file. For example, labels are made using makeLabel(########). The specifications for those methods can be found in 
  helper.pde. This ensures that a common methodology is used in making each label. It also vastly reduces the code base to make all of the controls. Every control follows a similar naming 
  convention. If a label is on the track main page, it will be called tml_#### where #### corresponds to whatever the label is for. Similarly, a button on the football title page would be 
  named ftb_####. A text field on the same page would be ftt_####.  
  
  Each page has its own containers for labels, buttons, text fields, and sometimes image buttons. Each container follows a similar syntax. The title labels are in t_labels. The
  track main page labels are tm_labels, etc. The labels are used in helper.pde to show/remove labels from page when switching screens. Every control on a page should be added to that
  page's container for that control to ensure that the control is made visible/invisible when switching pages. 
*/ 
import java.awt.Font;

//=============================================================================================================
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
  titlePaigeButton.addEventHandler(this, "titlePaigeReturn_click");
  //=============================================================================================================     
  //Title Page Setup
  tl_title = makeTitle(0, 100, frameWidth, 300, 100, tl_title, "LIGHT RUNNER", GAlign.CENTER, GAlign.TOP, true);
  tb_track = makeButton(frameWidth/2 - 300, 350, 200, 60, tb_track, "Track", true, "tb_track_click");
  tb_football = makeButton(frameWidth/2 + 100, 350, 200, 60, tb_football, "Football", true, "tb_football_click");
  //Title Page Containers 
  t_labels = new ArrayList<GLabel>();
  t_labels.add(tl_title);
  t_buttons = new ArrayList<GButton>(Arrays.asList(tb_track, tb_football));
  //=============================================================================================================
  //Track Main Page
  int adjust = 80;
  rowHeight = new int[]{90, 122, 154, 186}; //for runner rows, used in add/remove person
  tml_title = makeTitle(0, 0, frameWidth, 50, 40, tml_title, "Track", GAlign.CENTER, GAlign.TOP, false);
  tml_desiredLT = makeTitle(80 + adjust, 50, 200, 40, 18, tml_desiredLT, "Desired Lap Time (sec)", GAlign.LEFT, GAlign.TOP, false);  
  tml_adjustP = makeTitle(300 + adjust, 50, 200, 40, 20, tml_adjustP, "Adjust Pace", GAlign.LEFT, GAlign.TOP, false);
  tml_zero = makeTitle(450 + adjust, 50, 200, 40, 20, tml_zero, "Zero", GAlign.LEFT, GAlign.TOP, false); 
  tml_totalNOL = makeTitle(60 + adjust/2, 300, 200, 40, 20, tml_totalNOL, "Number of Laps", GAlign.RIGHT, GAlign.TOP, false);  
  tml_trackL = makeTitle(60 + adjust/2, 330, 200, 40, 20, tml_trackL, "Track Length (m)", GAlign.RIGHT, GAlign.TOP, false);  
  tml_remainingNOL = makeTitle(525 + adjust, 50, 200, 40, 20, tml_remainingNOL, "Remaining Laps", GAlign.LEFT, GAlign.TOP, false);
  tml_countdown = makeTitle(270, 500, 200, 40, 20, tml_countdown, "Enable Countdown", GAlign.RIGHT, GAlign.TOP, false);
  tml_paceT = makeTitle(60 + adjust/2, 271, 200, 40, 20, tml_paceT, "Pace Assist", GAlign.RIGHT, GAlign.TOP, false);
  tmt_totalNOL = makeTextField(270 + adjust/2, (int)tml_totalNOL.getY()+6, 40, 20, 16, tmt_totalNOL, "10", false, "noTextEventYet");
  tmt_trackL = makeTextField(270 + adjust/2, (int)tml_trackL.getY()+6, 40, 20, 16, tmt_trackL, "250", false, "noTextEventYet");
  tmc_countdown = new GCheckbox(this, 480, tml_countdown.getY()+3, 25, 25);
  tmc_countdown.setVisible(false);
  tmc_paceAssist = new GCheckbox(this, 270 + adjust/2, tml_paceT.getY()+2, 25, 25);
  tmc_paceAssist.setVisible(false);
  tmb_addPerson = makeButton(720 + adjust, rowHeight[0]-2, 25, 25, tmb_addPerson, "+", false, "tmb_addPerson_click");
  tmb_removePerson = makeButton(760 + adjust, rowHeight[1]-2, 25, 25, tmb_removePerson, "-", false, "tmb_removePerson_click");
  tmb_start = makeButton(140, 500, 150, 50, tmb_start, "Start", false, "tmb_start_click");
  tmb_reset = makeButton(140, 570, 150, 50, tmb_reset, "Reset", false, "tmb_reset_click");
  //=============================================================================================================
  //Make controls for each runner (max of 4 right now)
  //Each number is for that number runner. The items are on rows per player, with a height of 10 between rows
  int desiredLTX = (int) tml_desiredLT.getX()+15;
  tmt_desiredLT1 = makeTextField(desiredLTX, rowHeight[0], 150, 22, 18, tmt_desiredLT1, "0", false, "desiredLT_change");
  tmt_desiredLT2 = makeTextField(desiredLTX, rowHeight[1], 150, 22, 18, tmt_desiredLT2, "0", false, "desiredLT_change");
  tmt_desiredLT3 = makeTextField(desiredLTX, rowHeight[2], 150, 22, 18, tmt_desiredLT3, "0", false, "desiredLT_change");
  tmt_desiredLT4 = makeTextField(desiredLTX, rowHeight[3], 150, 22, 18, tmt_desiredLT4, "0", false, "desiredLT_change");  
  int adjustPX = (int)tml_adjustP.getX();
  tmb_adjustU1 = makeImageButton(adjustPX+10, rowHeight[0]-2, 25, 25, tmb_adjustU1, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU2 = makeImageButton(adjustPX+10, rowHeight[1]-2, 25, 25, tmb_adjustU2, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU3 = makeImageButton(adjustPX+10, rowHeight[2]-2, 25, 25, tmb_adjustU3, false, "tmb_adjustU_click", "up.png");
  tmb_adjustU4 = makeImageButton(adjustPX+10, rowHeight[3]-2, 25, 25, tmb_adjustU4, false, "tmb_adjustU_click", "up.png");
  tmb_adjustD1 = makeImageButton(adjustPX+55, rowHeight[0]-2, 25, 25, tmb_adjustD1, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD2 = makeImageButton(adjustPX+55, rowHeight[1]-2, 25, 25, tmb_adjustD2, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD3 = makeImageButton(adjustPX+55, rowHeight[2]-2, 25, 25, tmb_adjustD3, false, "tmb_adjustD_click", "down.png");
  tmb_adjustD4 = makeImageButton(adjustPX+55, rowHeight[3]-2, 25, 25, tmb_adjustD4, false, "tmb_adjustD_click", "down.png");
  int temp = (int)tml_zero.getX();
  tmb_zero1 = makeButton(temp, rowHeight[0]-2, 50, 25, tmb_zero1, "", false, "tmb_zero_click");
  tmb_zero2 = makeButton(temp, rowHeight[1]-2, 50, 25, tmb_zero2, "", false, "tmb_zero_click");
  tmb_zero3 = makeButton(temp, rowHeight[2]-2, 50, 25, tmb_zero3, "", false, "tmb_zero_click");
  tmb_zero4 = makeButton(temp, rowHeight[3]-2, 50, 25, tmb_zero4, "", false, "tmb_zero_click");
  temp = (int)tml_remainingNOL.getX()+adjust/2;
  tml_lapR1 = makeTitle(temp, rowHeight[0]-2, 50, 25, 20, tml_lapR1, "00", GAlign.CENTER, GAlign.CENTER, false);
  tml_lapR2 = makeTitle(temp, rowHeight[1]-2, 50, 25, 20, tml_lapR2, "00", GAlign.CENTER, GAlign.CENTER, false);
  tml_lapR3 = makeTitle(temp, rowHeight[2]-2, 50, 25, 20, tml_lapR3, "00", GAlign.CENTER, GAlign.CENTER, false);
  tml_lapR4 = makeTitle(temp, rowHeight[3]-2, 50, 25, 20, tml_lapR4, "00", GAlign.CENTER, GAlign.CENTER, false);
  tm_lapR = new GLabel[]{tml_lapR1, tml_lapR2, tml_lapR3, tml_lapR4};
  //=============================================================================================================
  //Track for visual of LED position on real track
  led = new GButton[4];
  ledMarker = new GButton[4];
  track = makeImageButton(520 - adjust/2, 250, 301, 140, track, false, "noImageButtonEventYet", "track3.png");
  track.setEnabled(false);
  
  for (int i=0; i<led.length; i++) {
    //ttt = makeButton((int)(track.getX()+track.getWidth()/2), (int)(track.getY()-led[0].getHeight()), 5, 5, ttt, "", true, "");
    led[i] = new GButton(this, track.getX()+(track.getWidth()/2), track.getY()+track.getHeight(), ledHeight, ledHeight);
    //led[i] = new GButton(this, track.getX()+(track.getHeight()/2), track.getY()+track.getHeight(), ledHeight, ledHeight);
    led[i].setEnabled(false);
    led[i].setAlpha(0);  
  }
  led[0].setLocalColorScheme(GConstants.RED_SCHEME);
  led[1].setLocalColorScheme(GConstants.GREEN_SCHEME);
  led[2].setLocalColorScheme(GConstants.BLUE_SCHEME);
  led[3].setLocalColorScheme(GConstants.YELLOW_SCHEME);
  
  int ledMarkerHeight = 15;
  
    for (int i=0; i<ledMarker.length; i++) {
     ledMarker[i] = makeButton(desiredLTX - 40, rowHeight[i]+5, ledMarkerHeight, ledMarkerHeight, ledMarker[i], "", false, "none");
  }
  
  ledMarker[0].setLocalColorScheme(GConstants.RED_SCHEME);
  ledMarker[1].setLocalColorScheme(GConstants.GREEN_SCHEME);
  ledMarker[2].setLocalColorScheme(GConstants.BLUE_SCHEME);
  ledMarker[3].setLocalColorScheme(GConstants.YELLOW_SCHEME);
  
  
  
  
  //=============================================================================================================
  //Final containers for track page
  tm_labels = new ArrayList<GLabel>(Arrays.asList(tml_title, tml_desiredLT, tml_adjustP, tml_zero, tml_totalNOL, tml_remainingNOL, tml_paceT, tml_trackL, tml_lapR1, tml_countdown));
  tm_buttons = new ArrayList<GButton>();
  tm_imageButtons = new ArrayList<GImageButton>(Arrays.asList(tmb_adjustU1, tmb_adjustD1,track));
  tm_buttons.addAll(Arrays.asList(tmb_zero1, tmb_addPerson, tmb_start, tmb_reset, ledMarker[0]));
  tm_textFields = new ArrayList<GTextField>(Arrays.asList(tmt_totalNOL, tmt_desiredLT1, tmt_trackL));
  tmt_desiredTimes = new GTextField[]{tmt_desiredLT1, tmt_desiredLT2, tmt_desiredLT3, tmt_desiredLT4};
  //=============================================================================================================
  //=============================================================================================================
  //Football Title Page Setup
  ftl_title = makeTitle(0, 0, frameWidth, 200, 100, ftl_title, "FOOTBALL", GAlign.CENTER, GAlign.TOP, false);
  ftb_dash = makeButton(200, 300, 250, 90, ftb_dash, "Forty-Yard Dash", false, "ftb_forty_click");
  ftb_fivetenfive = makeButton(550, 300, 250, 90, ftb_fivetenfive, "5-10-5", false, "noButtonEventYet");
  //Football Title Page Containers
  ft_labels = new ArrayList<GLabel>();
  ft_labels.add(ftl_title);
  ft_buttons = new ArrayList<GButton>(Arrays.asList(ftb_dash, ftb_fivetenfive));
  //=============================================================================================================
  //Football Main Page
  fml_title = makeTitle(0, 0, frameWidth, 50, 40, fml_title, "Forty-Yard Dash", GAlign.CENTER, GAlign.TOP, false);
  fml_desiredTime = makeTitle(frameWidth/2-250-50, 60, 270, 40, 30, fml_desiredTime, "Desired Time (sec)", GAlign.CENTER, GAlign.TOP, false);
  fmt_desiredTime = makeTextField(frameWidth/2+50, 65, 250, 30, 20, fmt_desiredTime, "", false, "noTextEventYet");
  fmt_desiredTime.setText("5");
  fmt_desiredTime.addEventHandler(this, "fmt_desiredTime_change");
  //=============================================================================================================
  fml_choosePosition = makeTitle(frameWidth/2-250-50, 120, 250, 40, 30, fml_choosePosition, "Choose Position", GAlign.CENTER, GAlign.TOP, false);
  fmd_choosePosition = new GDropList(this, frameWidth/2+50, 130, 250, 420, 15);
  footballPositions = new String[]{"None","Wide Receiver","Cornerback","Running Back","Safety","Outside Linebacker","Tight End","Full Back","Inside Linebcker","Quarterback","Defensive End","Defensive Tackle","Offensive Center","Offensive Tackle","Offensive Guard"};
  fmd_choosePosition.setItems(footballPositions,0);
  fmd_choosePosition.setVisible(false);
  fmd_choosePosition.addEventHandler(this, "fmd_choosePosition_click");
  //=============================================================================================================
  football_track = makeImageButton(147, 340, 706, 75, football_track, false, "football_track_click", "football_track.png");
  football_track.setEnabled(false);
  
  fml_acceleration = makeTitle(frameWidth/2-250-50, 180, 250, 40, 30, fml_acceleration, "Acceleration", GAlign.CENTER, GAlign.TOP, false);
  acceleration = new GCheckbox(this, 560, 190, 25, 25);
  acceleration.setVisible(false);
  //=============================================================================================================
  football_led = new GButton(this, football_track.getX(), football_track.getY()-football_led_height, football_led_height, football_led_height);
  football_led.setEnabled(false);
  football_led.setAlpha(0);   
  football_led.setLocalColorScheme(GConstants.RED_SCHEME);
  //=============================================================================================================
  fm_labels = new ArrayList<GLabel>(Arrays.asList(fml_title,fml_desiredTime,fml_choosePosition, tml_countdown,fml_acceleration));
  fm_imageButtons = new ArrayList<GImageButton>(Arrays.asList(football_track));
  fm_textFields = new ArrayList<GTextField>(Arrays.asList(fmt_desiredTime));
  fm_Buttons = new ArrayList<GButton>(Arrays.asList(tmb_start, tmb_reset)); 
  //=============================================================================================================
  //Final: Let this be the last code before the closing bracket in order to avoid null pointers
  labels = new ArrayList<List<GLabel>>(Arrays.asList(t_labels, ft_labels, tm_labels, fm_labels));
  textFields = new ArrayList<List<GTextField>>(Arrays.asList(tm_textFields, fm_textFields));
  buttons = new ArrayList<List<GButton>>(Arrays.asList(t_buttons, ft_buttons, tm_buttons));
  imageButtons = new ArrayList<List<GImageButton>>(Arrays.asList(tm_imageButtons, fm_imageButtons));
}
//=============================================================================================================
//=============================================================================================================
// Variable declarations 
GButton titlePaigeButton;
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
GImageButton tmb_adjustU1, tmb_adjustU2, tmb_adjustU3, tmb_adjustU4, tmb_adjustD1, tmb_adjustD2, tmb_adjustD3, tmb_adjustD4;
GLabel tml_title, tml_desiredLT, tml_adjustP, tml_zero, tml_totalNOL, tml_remainingNOL, tml_paceT, tml_trackL, tml_countdown;
GLabel tml_lapR1, tml_lapR2, tml_lapR3, tml_lapR4;
GButton tmb_zero1, tmb_zero2, tmb_zero3, tmb_zero4;
GButton tmb_addPerson, tmb_removePerson, tmb_paceT, tmb_start, tmb_reset;
GTextField tmt_desiredLT1, tmt_desiredLT2, tmt_desiredLT3, tmt_desiredLT4, tmt_totalNOL, tmt_trackL;
GTextField[] tmt_desiredTimes;
GCheckbox tmc_paceAssist, tmc_countdown;
GButton[] led;      //virtual led representing each runner
GButton[] ledMarker;
GImageButton track;
GLabel[] tm_lapR;
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
//Football Main Page
GCheckbox acceleration;
GLabel fml_title;
GLabel fml_desiredTime;
GLabel fml_choosePosition;
GLabel fml_acceleration;
GImageButton football_track;
GTextField fmt_desiredTime;
GButton football_led;
GDropList fmd_choosePosition;
String[] footballPositions; 
List<GLabel> fm_labels;
List<GImageButton> fm_imageButtons;
List<GTextField> fm_textFields;
List<GButton> fm_Buttons;
