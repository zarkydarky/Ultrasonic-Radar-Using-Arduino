/**
 * Ultrasonic Radar with Servo Sweep
 *
 * This sketch controls an HC-SR04 ultrasonic sensor mounted on a servo motor.
 * It performs a continuous 0°→180°→0° sweep, measures distance at each angle,
 * and sends “angle,distance.” strings over Serial for visualization.
 *
 * Connections:
 *   - trigPin (D2)   → HC‑SR04 Trig (with 1K Ω series resistor)
 *   - echoPin (D3)   → HC‑SR04 Echo
 *   - servo signal   → Servo signal line on D4
 *   - 5 V and GND    → common power/ground rails
 */

#include <Servo.h>            // Include Servo library for PWM control

// Pin definitions
#define trigPin 2              // Ultrasonic sensor trigger pin
#define echoPin 3              // Ultrasonic sensor echo pin

// Variables for distance calculation
long duration;                 // Time (µs) for echo return
int distance;                  // Calculated distance in cm

Servo myservo;                 // Servo object for controlling the sweep

/**
 * calculateDistance()
 *
 * Sends a 10 µs pulse on trigPin, measures the time until echoPin goes HIGH,
 * converts that duration into a distance (cm), and returns it.
 */
int calculateDistance() {
  // Ensure trigger is LOW for at least 2 µs
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  // Send a 10 µs HIGH pulse to trigger ultrasonic burst
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Read the duration of the HIGH pulse on echoPin
  duration = pulseIn(echoPin, HIGH);
  
  // Convert time (µs) to distance (cm): sound speed ≈ 0.034 cm/µs, divide by 2 for round trip
  distance = duration * 0.034 / 2;
  return distance;
}

void setup() {
  // Configure sensor pins
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  // Attach servo to pin 4
  myservo.attach(4);
  
  // Begin serial output for Processing visualization (9600 baud)
  Serial.begin(9600);
}

void loop() {
  // --- Sweep from 0° to 180° ---
  for (int pos = 0; pos <= 180; pos += 5) {
    myservo.write(pos);        // Move servo to current angle
    delay(30);                 // Short delay for smooth movement
    
    calculateDistance();       // Update `distance`
    
    // Send formatted data: "angle,distance."
    Serial.print(pos);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

  // --- Sweep from 180° back to 0° ---
  for (int pos = 180; pos >= 0; pos -= 5) {
    myservo.write(pos);
    delay(30);
    
    calculateDistance();
    
    Serial.print(pos);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}
