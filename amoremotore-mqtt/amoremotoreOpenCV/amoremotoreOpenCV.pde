import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

int width = 640;
int height = 480;

void setup() {
  size(640, 480);

  cam = new Capture(this, width, height, 30);
  opencv = new OpenCV(this, width, height);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

  cam.start();     
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
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
}
