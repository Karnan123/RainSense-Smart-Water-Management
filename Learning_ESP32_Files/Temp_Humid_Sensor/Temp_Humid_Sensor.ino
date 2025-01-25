#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

// Define the DHT sensor type and the GPIO pin
#define DHTPIN 4     // Use GPIO4 (D2 on NodeMCU)
#define DHTTYPE DHT22 // DHT22 sensor type

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  dht.begin();
  delay(2000);

  Serial.begin(115200);
  Serial.println(F("DHT22 Sensor Test"));
}

void loop() {
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();  // Default is Celsius

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  Serial.print(F("Humidity: "));
  Serial.print(humidity);
  Serial.print(F("%  Temperature: "));
  Serial.print(temperature);
  Serial.println(F("°C"));

  delay(2000); // Wait before reading again
}