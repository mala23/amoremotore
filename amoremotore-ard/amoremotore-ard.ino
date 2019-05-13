#include <WiFi.h>
#include <PubSubClient.h>

uint64_t chip_id;

const char* wifi_ssid = "(*)";
const char* wifi_password =  "NC65t2a7nwrd";
const char* broker_ip = "192.168.0.4";

WiFiClient espClient;
PubSubClient client(espClient);

const char* client_id = "ESP32Client";

uint8_t PIN1 = 13;
uint8_t PIN2 = 12;
uint8_t PIN3 = 14;
uint8_t PIN4 = 27;
uint8_t PIN5 = 26;
uint8_t PIN6 = 25;
uint8_t PIN7 = 33;
uint8_t PIN8 = 32;

uint8_t pins[] = {PIN1,PIN2,PIN3,PIN4,PIN5,PIN6,PIN7,PIN8};

void write_pin(int pin_index, bool command) {
  if (command) {
    digitalWrite(pins[pin_index], HIGH);
  } else {
    digitalWrite(pins[pin_index], LOW);
  }
}

void set_state(int pin_index, int command) {
  if (command >> 1) {
    // move one direction
  } else {
    // move the other direction
  }

  if (command & 0b1) {
    write_pin(pin_index, true);
  } else {
    write_pin(pin_index, false);
  }
}

void wave() {
  write_pin(0, true);
  delay(30);
  write_pin(1, true);
  delay(30);
  write_pin(0, false);
  write_pin(2, true);
  delay(30);
  write_pin(1, false);
  write_pin(3, true);
  delay(30);
  write_pin(2, false);
  write_pin(4, true);
  delay(30);
  write_pin(3, false);
  write_pin(5, true);
  delay(30);
  write_pin(4, false);
  write_pin(6, true);
  delay(30);
  write_pin(5, false);
  write_pin(7, true);
  delay(30);
  write_pin(6, false);
  delay(30);
  write_pin(7, false);
}

void write_all_pins(bool val) {
  for(int i = 0; i < 8; i++) {
    write_pin(i, val);
  }
}

void flash() {
  delay(500);
  write_all_pins(true);
  delay(200);
  write_all_pins(false);
  delay(500);
}

int str_to_bit(char str) {
  if ('0' == str) {
    return 0b00;
  } else {
    return 0b11;
  }
}

// XXX: transmit byte* to shift register
void apply_bytes_to_state(byte* payload) {
  uint16_t control_bits = payload[1] | ((uint16_t)payload[0] << 8);
  for (int i = 0; i < 8; i++) {
    set_state(i, control_bits & 0b11);
    control_bits >>= 2;
  }
}

void mqtt_callback(char* topic, byte* raw_payload, unsigned int length) {
  byte payload[2] = {0, 0};
  if (length == 16) {
    for (int y = 0; y < 16; y++) {
      if (y < 8) {
        uint shift = (7 - y);
        payload[0] |= str_to_bit((char)raw_payload[y]) << shift;
      } else {
        int shift = (7 - (y - 8));
        payload[1] |= str_to_bit((char)raw_payload[y]) << shift;
      }
    }
  } else {
    payload[0] = raw_payload[0];
    payload[1] = raw_payload[1];
  }

  if (length > 0) {
    apply_bytes_to_state(payload);
  }

  // display current frame for at least half a second
  delay(500);
}

void mqtt_connect() {
  while(!client.connected()) {
    if (client.connect(client_id)) {
      client.subscribe("MOTORS");
    } else {
      wave();
    }
  }
}

void setup() {
  Serial.begin(115200);

  pinMode(PIN1, OUTPUT);
  pinMode(PIN2, OUTPUT);
  pinMode(PIN3, OUTPUT);
  pinMode(PIN4, OUTPUT);
  pinMode(PIN5, OUTPUT);
  pinMode(PIN6, OUTPUT);
  pinMode(PIN7, OUTPUT);
  pinMode(PIN8, OUTPUT);

  WiFi.begin(wifi_ssid, wifi_password);

  while (WiFi.status() != WL_CONNECTED) {
    wave();
  }

  flash();
  flash();

  client.setServer(broker_ip, 1883);
  client.setCallback(mqtt_callback);
}

void loop() {
  mqtt_connect();
  client.loop();
}
