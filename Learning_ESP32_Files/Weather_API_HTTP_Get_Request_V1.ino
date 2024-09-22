#include <Arduino_JSON.h>
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "";
const char* password = "";

void setup() {

  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);
  delay(4000);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wifi");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }

  Serial.print("Connected to WiFi Network");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if ((WiFi.status() == WL_CONNECTED)) {
    digitalWrite(LED_PIN, HIGH);
    
    HTTPClient http;

    http.begin("Insert HTTP Here");

    int httpCode = http.GET();

    if (httpCode > 0) {

      String JSON = http.getString();
      Serial.println(httpCode);
      Serial.println(JSON);
    }

    else {
      Serial.print("httpCode error");
    }

    http.end();

  }
  else {
    Serial.println("WiFi Connection Lost");
    digitalWrite(LED_PIN, LOW);
  }

  digitalWrite(LED_PIN, LOW);
  delay(60000);
}
