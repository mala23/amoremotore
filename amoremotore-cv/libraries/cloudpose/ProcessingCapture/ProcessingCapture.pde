import processing.net.*;
import processing.video.*;

Capture video;

Client client; 

Person[] people;

boolean sent = false;
long time;
long delay;

void setup() {
  size(320, 200);

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
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 2)) && (person.points[Person.MidHip].x >= (width / 8)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT2");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 3)) && (person.points[Person.MidHip].x >= (width / 8 * 2)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT3");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 4)) && (person.points[Person.MidHip].x >= (width / 8 * 3)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT4");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 5)) && (person.points[Person.MidHip].x >= (width / 8 * 4)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT5");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 6)) && (person.points[Person.MidHip].x >= (width / 8 * 5)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT6");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 7)) && (person.points[Person.MidHip].x >= (width / 8 * 6)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT7");
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 8)) && (person.points[Person.MidHip].x >= (width / 8 * 7)) && (person.points[Person.MidHip].x != 0)) {
        println("MOT8");
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
