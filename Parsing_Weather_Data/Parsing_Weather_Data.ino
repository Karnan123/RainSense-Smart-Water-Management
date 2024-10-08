#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <WebServer.h>

const char* ssid = "";
const char* password = "";
const int LED_PIN = 2;
String weatherRawData;
const long interval = 60000;
unsigned long prevMilli = 0;

WebServer server(80);

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
  Serial.print("\nIP address: ");
  Serial.println(WiFi.localIP());

  server.on("/data", HTTP_GET, handleData);

  // server.on("/", HTTP_GET, []() {
  //   server.send(200, "text/plain", "Server is running");
  // });

  server.begin();
  Serial.print("\nServer Begins");
}

String httpGETRequest(const char* weatherLink) {

  HTTPClient http;

  String weatherData = "{}";

  http.begin(weatherLink);
  int httpCode = http.GET();

  if (httpCode > 0) {

    weatherData = http.getString();
    Serial.println(httpCode);
    //Serial.println(weatherData);
  }
  else {
    Serial.print("httpCode error");
  }
  http.end();
  return weatherData;
}

void handleData() {

  Serial.println("Handling /data request...");
  server.sendHeader("Content-Type", "application/json");
  server.send(200, "application/json", weatherRawData);
}

void loop() {
  
  unsigned long currMilli = millis();

  if ((WiFi.status() == WL_CONNECTED)) {

    if (currMilli - prevMilli >= interval) {

      prevMilli = currMilli;

      digitalWrite(LED_PIN, HIGH);

      String weatherLink = "";

      weatherRawData = httpGETRequest(weatherLink.c_str());

      JSONVar myWeatherData = JSON.parse(weatherRawData);

      if (JSON.typeof(myWeatherData) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }
    }

    server.handleClient();
    
    // Serial.print("Weather Data: ");
    // Serial.println(myWeatherData);
    // Serial.print("Temperature: ");
    // Serial.println(myWeatherData["list"][0]["main"]["temp"]);
  }
  else {
    Serial.print("WiFi Connection Lost");
    digitalWrite(LED_PIN, LOW);
  }

  digitalWrite(LED_PIN, LOW);
}