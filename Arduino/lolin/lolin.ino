#include <WiFiClient.h>
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <ESP8266HTTPClient.h>
SoftwareSerial loliSerial(D6, D7); // RX, TX

const char* ssid = "SuperXEiLL";
const char* password = "";
WiFiClient client;



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
  llamadaApiBbdd("pepe");

  // Leer mensaje del Arduino Uno
  if (loliSerial.available()) {
    String mensaje = loliSerial.readStringUntil('\n');
    Serial.print("Recibido del Arduino Uno: ");
    Serial.println(mensaje);
    llamadaApiBbdd(mensaje);
  } else {
    Serial.println("No hay respuesta del Arduino Uno");
  }
}

void llamadaApiBbdd(String mensaje){
if ((WiFi.status() == WL_CONNECTED) && false) { //comprobar
    HTTPClient http;
  
    http.begin(client,"");
    int httpCode = http.GET();   
    Serial.println(http.getString());                                    
    if (httpCode > 0) { //ruta
  
        String payload = http.getString();
        Serial.println(payload);
      }
  
    else {
      Serial.println("Error on HTTP request");
    }
  
    http.end(); //Free the resources
  }
  

  
}
