//data scroll to compose with frames from the camera with pan-movement

XML xml;

PImage img; // just to view composition. Then remove

PFont font;

ScrollingText texts[];

void setup() {
  size(1280, 720);
  frameRate(24);
  
  // background
  img = loadImage("image.png"); // just to view composition. Then remove
  
  // font
  font = loadFont("ArialUnicodeMS-20.vlw");
  textFont(font);
  textSize(25);
  
  // load XML data
  loadTextsFromXML();
}

void draw() {
  background(0);
  noStroke();
  fill(255);
  
  image(img, 0, 0); // just to view composition. Then remove
  
  // moving-text background
  fill(250);
  rect(0, height-110, width, 40);
  
  // moving-text
  fill(0);
  for (int i = 0; i < texts.length; i++) {
    texts[i].render(true);
  }
  
  // restart text banner when finished
  if(texts[texts.length-1].getXPos() < texts[texts.length-1].getWidth()-((width/2)+140)){
    for (int i = 0; i < texts.length; i++) {
      texts[i].resetPos();
    }
  }
  
  // still-text background
  fill(0);
  rect(0, height-150, 360, 40);
  
  // still-text
  fill(255);
  text("IVAM 2020. En milers d'euros", 10, height-125);
  
}

void loadTextsFromXML(){
  // laod xml file
  xml = loadXML("datos_ivam_2020.xml");
  
  // extract childrens
  XML[] children = xml.getChildren("dato");
  
  // create an array of ScrollingText
  texts = new ScrollingText[children.length-1];
  
  // SCROLL LEFT
  float actualXPos = width+10; // we start scrolling from right
  
  
  for (int i = 1; i < children.length; i++) {
    // init ScrollingText
    texts[i-1] = new ScrollingText();
    
    // extract data
    String name = children[i].getString("tipo");       // data name
    String data = children[i].getContent();            // data
    String txt = name + ": " + data + "  |  ";         // full text
   
    // assign text
    texts[i-1].setText(txt);
    // assign initial position
    texts[i-1].setStartXPos(actualXPos);
    // assign Y position (fixed)
    texts[i-1].setYPos(height-80);
    
    // increment reference position for next ScrollingText
    actualXPos += texts[i-1].getWidth();
    
  }
}
