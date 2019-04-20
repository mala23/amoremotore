import mqtt.*;

MQTTClient client;

void setup() {
  client = new MQTTClient(this);
  client.connect("mqtt://192.168.0.4", "processing");
}

void draw() {}

void keyPressed() {
  send(4, true);
}

void send(int pos, boolean dir) {
  byte[] payload = new byte[2];
  if (pos < 4) {
    payload[0] |= 3 << (pos * 2);
  } else {
    payload[1] |= 3 << ((pos - 4) * 2);
  }
  client.publish("MOTORS", payload);
}

void clientConnected() {
  println("client connected");
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}

void connectionLost() {
  println("connection lost");
}
