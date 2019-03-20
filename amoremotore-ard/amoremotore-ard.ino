#include <YunClient.h>

YunClient net;

unsigned long lastMillis = 0;

int latchPin = 6;  // Latch pin of 74HC595 is connected to Digital pin 5
int clockPin = 5; // Clock pin of 74HC595 is connected to Digital pin 6
int dataPin = 4;  // Data pin of 74HC595 is connected to Digital pin 4

uint16_t motors = 0;

void setup() {
  Serial.begin(9600);

  // Set all the pins of 74HC595 as OUTPUT
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
}

void loop() {
  // check if data is available
  if (Serial.available() > 0)
  {
    // read string
    String str = Serial.readStringUntil('\n');
    Serial.print(str);

    motors = 0b1010101010101010;
    updateShiftRegister(str);
  }
}

void updateShiftRegister(bytes)
{
  digitalWrite(latchPin, LOW);
  //digitalWrite(clockPin, LOW);
  shiftOut(dataPin, clockPin, LSBFIRST, motors);
  shiftOut(dataPin, clockPin, LSBFIRST, (bytes);
  digitalWrite(latchPin, HIGH);
}
