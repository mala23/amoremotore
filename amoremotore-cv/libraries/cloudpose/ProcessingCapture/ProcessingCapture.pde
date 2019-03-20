import processing.net.*;
import processing.video.*;
import processing.serial.*;

Serial amoremotoreMod01Port;

Capture video;

Client client; 

Person[] people;

boolean sent = false;
long time;
long delay;

void setup() {
  println(Serial.list());
  size(320, 200);
  amoremotoreMod01Port new Serial(this, "/dev/cu.usbmodem141001", 9600);

  //println(Capture.list());
  
  //video = new Capture(this, width, height, "HD Pro Webcam C920", 15);
  video = new Capture(this, width, height, 15);
  video.start();
  
  client = new Client(this, "cloudpose.joelgaehwiler.com", 1337); 
}

void draw() {
  // read video frame if available
  if (video.available()) {
    video.read();
  }
  
  // read client data if available
  if (client.available() > 0) {
    // read frame length
    int length = decodeInt(client.readBytes(8));
    
    // read frame
    people = decodeJSON(decodeString(client.readBytes(length)));
    
    // log
    //println("received " + (8 + length));
    
    // set flag
    sent = false;
    delay = millis() - time;
  }
  
  // draw video image
  image(video, 0, 0);
  
  // draw people
  if (people != null) {
    for (Person person : people) {
      person.draw();
      if ((person.points[Person.MidHip].x <= (width/8)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT1");
				myPort.write(str(MOT1));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 2)) && (person.points[Person.MidHip].x >= (width / 8)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT2");
				myPort.write(str(MOT2));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 3)) && (person.points[Person.MidHip].x >= (width / 8 * 2)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT3");
				myPort.write(str(MOT3));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 4)) && (person.points[Person.MidHip].x >= (width / 8 * 3)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT4");
				myPort.write(str(MOT4));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 5)) && (person.points[Person.MidHip].x >= (width / 8 * 4)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT5");
				myPort.write(str(MOT5));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 6)) && (person.points[Person.MidHip].x >= (width / 8 * 5)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT6");
				myPort.write(str(MOT6));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 7)) && (person.points[Person.MidHip].x >= (width / 8 * 6)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT7");
				myPort.write(str(MOT7));
				myPort.write("\n");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 8)) && (person.points[Person.MidHip].x >= (width / 8 * 7)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT8");
				myPort.write(str(MOT8));
				myPort.write("\n");
      }
    }
  }
  
  // draw delay
  text(delay, 10, 20);
  
  if (!sent) {
    // encode image
    byte[] encoded = encodeJPG(video);
    
    // encode length
    byte[] length = encodeInt(encoded.length);
    
    // send data
    client.write(length);
    client.write(encoded);
    
    // log
    //println("sent " + (8 + encoded.length));
    
    // set flag
    sent = true;
    time = millis();
  }
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
}
