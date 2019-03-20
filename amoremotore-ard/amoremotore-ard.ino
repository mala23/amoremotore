#include <YunClient.h>

YunClient net;

unsigned long lastMillis = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  // check if data is available
  if (Serial.available() > 0)
  {
    // read string
    String str = Serial.readStringUntil('\n');
    Serial.print(str);
  }
}
