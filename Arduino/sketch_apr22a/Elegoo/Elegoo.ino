#include <ESP8266WiFi.h>
void setup() {
  Serial.begin(9600);
  Serial.println("Se conecta al wifi del puig");
 
  Serial.println("Yago");
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  } else {
        Serial.println("WiFi shield  present");
        WiFi.begin("SuperXEiLL");
        Serial.print("Connecting");
        while (WiFi.status() != WL_CONNECTED)
        {
          delay(500);
          Serial.print(".");
        }
        Serial.println();
      
        Serial.print("Connected, IP address: ");
        Serial.println(WiFi.localIP());
  
  }
  
}

void loop() {
  
  delay(1000);
} 
