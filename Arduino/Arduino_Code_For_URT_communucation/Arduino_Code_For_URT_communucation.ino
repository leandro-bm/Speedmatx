#include <SoftwareSerial.h>
SoftwareSerial loliSerial(2 , 4); // RX, TX


void setup() {
  Serial.begin(9600);
  loliSerial.begin(9600);
  Serial.println("Iniciando NodeMCU...");
}

void loop() {
  // Enviar mensaje al Arduino Uno
  loliSerial.println("Bien Lolin");
  Serial.println("intento enviado");
  delay(1000);

  // Leer mensaje del Arduino Uno
  if (loliSerial.available()) {
    String mensaje = loliSerial.readStringUntil('\n');
    Serial.print("Recibido del lolin: ");
    Serial.println(mensaje);
  }
}
