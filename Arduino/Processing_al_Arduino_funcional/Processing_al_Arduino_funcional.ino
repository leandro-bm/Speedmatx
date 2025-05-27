#include <SoftwareSerial.h>
SoftwareSerial nodeSerial(2, 4 ); // RX, TX (cambiamos TX a pin 3)

void setup() {
  Serial.begin(9600);
  nodeSerial.begin(9600);
}

void loop() {
  // Leer mensaje del processing
  delay(1000);
  if (Serial.available()) {
    String mensaje = Serial.readStringUntil('\n');
    nodeSerial.println(mensaje);
  }else {
  }
}
