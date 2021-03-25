import processing.video.*;
import java.awt.*;
import processing.serial.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
PGraphics offscreen;

Serial myPort;

Capture camera;
PVector PbrightnessPoint = new PVector();
PVector brightestPoint = new PVector(0, 0);
Pointer pointer = new Pointer(250, 250);
float brightestValue = 0;
void setup() {
  //size(1280, 960, P3D);
  fullScreen(P3D);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width, height, 20);
  offscreen = createGraphics(width, height, P3D);
  myPort = new Serial(this, "COM30", 115200);
  background(0);
  noStroke(); 
  String[] cameras = Capture.list();
  for (int i =0; i<cameras.length; i++) {
    println("["+i+"]"+cameras[i]);
  }
  camera = new Capture(this, cameras[7]);
  camera.start();
  myPort.clear();
  myPort.bufferUntil(10);
}



void draw() {
  offscreen.beginDraw();
  
  //外枠の縁取り
  offscreen.fill(255);
  offscreen.rect(0, 0, 3, height);
  offscreen.rect(0, 0, width, 3);
  offscreen.rect(0, height-3, width, height);
  offscreen.rect(width-3, 0, width, height);
  
  //左上にスプレーの色を表示
  offscreen.fill(pointer.getterR(), pointer.getterG(), pointer.getterB());
  offscreen.rect(width-50, 0, 50, 50);
  
  if(camera.available() == true){
    camera.read();
  }
  
  //offscreen.image(camera,0,0);
  int index = 0;
  float brightestValue = 0;
  camera.loadPixels();
  for (int y = 0; y < camera.height; y++) {
    for (int x = 0; x < camera.width; x++) {
      int pixelValue = camera.pixels[index];
      float pixelBrightness = brightness(pixelValue);
      if (pixelBrightness > brightestValue) {
        brightestValue = pixelBrightness;
        brightestPoint.x = x;
        brightestPoint.y = y;
      }
      index++;
    }
  }
  println(brightestPoint);
  pointer.setterX(int(brightestPoint.x*3));
  pointer.setterY(int(brightestPoint.y*2.25*1.5));

  if (brightestValue == 255) {
    //spray effect
    int radius = pointer.getterRadius();
    for (int i = pointer.getterX()-radius; i < pointer.getterX()+radius; i++) {
      for (int j = pointer.getterY()-radius; j < pointer.getterY()+radius; j++) {
        if ((int)(Math.random()*(radius*0.9)) <= radius - pointer.distance(i, j)) {
          color c = color(pointer.getterR(), pointer.getterG(), pointer.getterB());
          offscreen.stroke(pointer.scale(c));
          offscreen.point(i, j);
        }
      }
    }
  } 
  offscreen.endDraw();
  background(0);
  surface.render(offscreen);
}



void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  
  case ' ':
    offscreen.background(0);
  }
}


void serialEvent(Serial p) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    int[] espVal = int(split(inString, ','));
    pointer.setterR(espVal[0]);
    pointer.setterG(espVal[1]);
    pointer.setterB(espVal[2]);
    pointer.setterRadius(constrain(espVal[3], 0, 200));
  }
}
