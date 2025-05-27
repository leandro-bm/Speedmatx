#include <WiFiClient.h>
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <ESP8266HTTPClient.h>
SoftwareSerial loliSerial(D6, D7); // RX, TX

const char* ssid = "SuperXEiLL";
const char* password = "";
WiFiClient client;
HTTPClient http;

void setup() {
  Serial.begin(9600);
  loliSerial.begin(9600);
  Serial.println("Iniciando NodeMCU...");

  delay(1000);
  WiFi.begin(ssid);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  Serial.println("Connected to the WiFi network");
}

void loop() {
  // Enviar mensaje al Arduino Uno
  loliSerial.println("Hola que haces Arduino");

  delay(1000);
  // Leer mensaje del Arduino Uno
  if (loliSerial.available()) {
    String mensaje = loliSerial.readStringUntil('\n');
    mensaje.trim();


    Serial.print("Recibido del Arduino Uno: ");
    Serial.println(mensaje);
  
    if (mensaje != "No data") {
      String cabecera = "Recibido del processing: ";
      llamadaApiBbdd(mensaje);
    } else {
      Serial.println("Mensaje 'no data' recibido. No se envía a la API.");
    }
  }
}

void llamadaApiBbdd(String mensaje) {
  Serial.println("Conectado?");
  if ((WiFi.status() == WL_CONNECTED)) { //comprobar
    Serial.println("Si");

    String api = "http://192.168.238.213:8080/insertuser?data=" + mensaje;
    Serial.print(api);
    http.begin(client, api);
    Serial.println("peticiones haciendose");
    int httpCode = http.GET();
    Serial.println("peticiones hecha: " + String(httpCode));
    http.end(); //Free the resources
  }

}
