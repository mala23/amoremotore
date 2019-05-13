import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import mqtt.*;

Capture cam;
OpenCV opencv;
MQTTClient client;

int width = 640;
int height = 480;

void setup() {
  size(640, 480);

  cam = new Capture(this, width, height, 30);
  opencv = new OpenCV(this, width, height);
  client = new MQTTClient(this);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

  cam.start();     

  client.connect("mqtt://192.168.0.4", "processing");
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  opencv.loadImage(cam);

  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  String bytes = "0000000000000000";
  for (Contour contour : opencv.findContours()) { 
    contour.draw();
    Rectangle box = contour.getBoundingBox();
    int boxCenter = checkSection(box.getCenterX()) * 2 + 1;
    bytes = bytes.substring(0, boxCenter)+'1'+bytes.substring(boxCenter + 1);
  }
  println(bytes);
  client.publish("MOTORS", bytes);
  delay(100);
}

int checkSection(double area) {
  if (area <= (width / 8)) {
    return 0;
  } else if (area <= (width / 7) && area >= (width / 8)) {
    return 1;
  } else if (area <= (width / 6) && area >= (width / 7)) {
    return 2;
  } else if (area <= (width / 5) && area >= (width / 6)) {
    return 3;
  } else if (area <= (width / 4) && area >= (width / 5)) {
    return 4;
  } else if (area <= (width / 3) && area >= (width / 4)) {
    return 5;
  } else if (area <= (width / 2) && area >= (width / 3)) {
    return 6;
  } else {
    return 7;
  }
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
