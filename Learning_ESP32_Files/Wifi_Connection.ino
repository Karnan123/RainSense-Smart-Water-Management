#include <WiFi.h>;

const char* ssid = "";
const char* password = "";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wifi");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.print("Connected to WiFi Network");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if ((WiFi.status() == WL_CONNECTED)) {
    Serial.println("Ping Me");
    delay(5000);
  }
  else {
    Serial.println("WiFi Connection Lost");
  }
}
