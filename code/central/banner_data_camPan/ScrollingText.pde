class ScrollingText {
  
  float startXPos;
  float xPos;
  float yPos;
  float w;
  float speed;
  String text;
  
  ScrollingText(){
     text = "";
     w = 0;
     
     startXPos = 0;
     xPos = 0;
     yPos = 0;
     speed = 2;    
  }
  
  void setStartXPos(float x){
    startXPos = x;
    xPos = x;
  }
  
  void setYPos(float y){
    yPos = y;
  }
  
  void setText(String t){
    text = t;
    w = textWidth(text);
  }
  
  void setSpeed(float s){
    speed = s;
  }
  
  float getXPos(){
    return xPos; 
  }
  
  float getWidth(){
    return w; 
  }
  
  void resetPos(){
    xPos = startXPos;
  }
  
  void render(boolean scrollLeft){
    if(scrollLeft){
      xPos -= speed;
    }else{
      xPos += speed;
    }
    
    text(text,xPos,yPos);
  }
  
}
