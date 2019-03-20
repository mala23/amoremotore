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

String[] bytes = {"0b", "00", "00", "00", "00", "00", "00", "00", "00"};
long bytesTime;
String bytesStr;

void setup() {
  //println(Serial.list());
  size(320, 200);
  amoremotoreMod01Port = new Serial(this, "/dev/cu.usbmodem14101", 9600);
  println("serial connected");

  //println(Capture.list());
  
  //video = new Capture(this, width, height, "HD Pro Webcam C920", 15);
  video = new Capture(this, width, height, 15);
  video.start();
  
  client = new Client(this, "cloudpose.joelgaehwiler.com", 1337); 
}

void draw() {
  // set the bytes every second
  if (millis() > (bytesTime + 1000)) {
    bytesStr = join(bytes, "");
    setBytes(bytesStr);
    bytesTime = millis();
  }

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
        //println("MOT1");
        bytes[1] = "01";
      } else {
        bytes[1] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 2)) && (person.points[Person.MidHip].x >= (width / 8)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT2");
        bytes[2] = "01";
      } else {
        bytes[2] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 3)) && (person.points[Person.MidHip].x >= (width / 8 * 2)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT3");
        bytes[3] = "01";
      } else {
        bytes[3] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 4)) && (person.points[Person.MidHip].x >= (width / 8 * 3)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT4");
        bytes[4] = "01";
      } else {
        bytes[4] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 5)) && (person.points[Person.MidHip].x >= (width / 8 * 4)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT5");
        bytes[5] = "01";
      } else {
        bytes[5] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 6)) && (person.points[Person.MidHip].x >= (width / 8 * 5)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT6");
        bytes[6] = "01";
      } else {
        bytes[6] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 7)) && (person.points[Person.MidHip].x >= (width / 8 * 6)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT7");
        bytes[7] = "01";
      } else {
        bytes[7] = "00";
      }
      if ((person.points[Person.MidHip].x <= (width / 8 * 8)) && (person.points[Person.MidHip].x >= (width / 8 * 7)) && (person.points[Person.MidHip].x != 0)) {
        //println("MOT8");
        bytes[8] = "01";
      } else {
        bytes[8] = "00";
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

void setBytes(String bytes) {
  //println(bytes);
  amoremotoreMod01Port.write(bytes);
  amoremotoreMod01Port.write("\n");
}

void serialEvent(Serial p) {
  // get message till line break (ASCII > 13)
  int message = amoremotoreMod01Port.read();
  println(message);
}
