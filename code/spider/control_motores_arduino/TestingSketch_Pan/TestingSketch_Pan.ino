// Include the servo library:
#include <Servo.h>

// Create a new servo object:
Servo panServo;
Servo tiltServo;

#define panPin 9
#define tiltPin 6


// Create a variable to store the servo position:
int pan = 0;
int tilt = 0;

int delayTime = 60000/360;

void setup() {
  
  panServo.attach(panPin);
  tiltServo.attach(tiltPin);

}

void loop() {
  
  tiltServo.write(60);

  // Sweep from 0 to 180 degrees:
  for (pan = 0; pan <= 180; pan += 1) {
    panServo.write(pan);
    delay(delayTime);
  }

  // And back from 180 to 0 degrees:
  for (pan = 180; pan >= 0; pan -= 1) {
    panServo.write(pan);
    delay(delayTime);
  }
  
}
