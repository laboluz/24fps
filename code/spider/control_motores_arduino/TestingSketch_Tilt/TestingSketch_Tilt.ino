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
  
  panServo.write(60);

  // Sweep from 30 to 100 degrees:
  for (tilt = 30; tilt <= 100; tilt += 1) {
    tiltServo.write(tilt);
    delay(delayTime);
  }

  // And back from 100 to 30 degrees:
  for (tilt = 100; tilt >= 30; tilt -= 1) {
    tiltServo.write(tilt);
    delay(delayTime);
  }
  
}
