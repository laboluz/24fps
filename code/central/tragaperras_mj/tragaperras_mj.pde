

int numFrames = 5; // animation frames number   
int maxTime = 8000; // 8 seg -- it will be updated in random
int lastTime = 0;  // for timing animation sequences

// images
PImage[] images = new PImage[numFrames]; // Image array
PImage mask; 

// Y positions images
int []posy = {0, 720, 1440, 2160, 2880};
int lastY = 2160;
int incY = 40;

// To select the camera 
int count = 0;
int CameraTime = 400; // time to selected camera streaming (simulation)
int camera = 0; // selected camera
int estado = 0;


void setup() {
size(1280, 720);

// Automate image loading  
for (int i = 0; i < images.length; i++) {
    // Construct the image name to load
    String imageName = "imag" + i + ".jpg";
    images[i] = loadImage(imageName);
  }
  mask = loadImage("mask.png"); // curve mask
  
  maxTime = int(random(4000, 8000)); // first maxTime duration
}

void draw() {
 
  if (estado == 0){
    if ((millis() - lastTime) < maxTime) {
       for(int i = 0; i < images.length; i++){
         posy[i] =  posy[i]-incY;
         moveFrame();
         // draw images and moving them horizontally
         image(images[i], 0, posy[i], 1280, 720);
       }
    }else{
      estado = 1;
      selectCamera();
    }
  }
  image(mask, 0, 0, 1280, 720); 
 // println(estado);
  if (estado == 1){
    count +=1;
    drawCamera();
    if (count > CameraTime){
      // Calculate a new duration for maxTime
      reset(); 
      count = 0;
      lastTime = millis();
      estado = 0;
    }
  }
}

void reset(){
  // Calculate a new duration for maxTime
  maxTime = int(random(4000, 8000));
}

void moveFrame(){ 
  // moves frame vertically, Y position
  for(int i = 0; i < images.length; i++){
    if (posy[i] < -720) {
      posy[i] =  lastY;
    }  
  }  
}

void selectCamera() {                
  /// select  camera of the last image
  for (int i = 0; i < images.length; i++) {   
    if ((posy[i] < 360) && (posy[i] > -360)) {
      camera = i;
      println(i);
    }
  }
}

void drawCamera(){
  if (estado == 1){
     for(int i = 0; i < images.length; i++){
       if(camera == i){
       image(images[i], 0, 0, 1280, 720);
       // Construct the camera num 
       String numCamera = "Camera " + i;
       text(numCamera, 40, 40);
       }
     }
  }
}
