void setup(){
  fullScreen(P2D, SPAN);
  //size(2560,720);
}

void draw(){
 //borde
 fill(0,0,200);
 rect(0,0,2560,720);
 
 //pantalla izq.
 fill(200,0,0);
 rect(10,10,1270,710);
 
 //pantalla dcha.
 fill(200,0,0);
 rect(10,10,2550,710);
}
