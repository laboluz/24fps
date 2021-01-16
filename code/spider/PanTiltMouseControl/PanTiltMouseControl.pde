/*
arduino_servo
  
For more information, see: http://playground.arduino.cc/Interfacing/Processing
*/

import processing.serial.*;

import cc.arduino.*;

Arduino arduino;

void setup() {
  size(360, 200);
  
  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
  // Configure digital pins 6 and 9 to control servo motors.
  arduino.pinMode(9, Arduino.SERVO); // PAN
  arduino.pinMode(6, Arduino.SERVO); // TILT
}

void draw() {
  background(constrain(mouseX / 2, 0, 180));
  
  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(9, constrain(mouseX, 0, 180));
  arduino.servoWrite(6, constrain(mouseY, 30, 100));
}
