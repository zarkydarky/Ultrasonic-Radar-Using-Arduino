import processing.serial.*;               // serial communication library

Serial myPort;                             // Serial object

String angle = "";
String distance = "";
String data = "";
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;

void setup() {
  fullScreen();                           // use entire screen at native resolution
  smooth();
  myPort = new Serial(this, "COM9", 9600);
  myPort.bufferUntil('.');                
}

void draw() {
  // clear with slight fade
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  // draw radar background
  strokeWeight(2);
  stroke(98, 245, 31);
  noFill();
  drawRadar();
  
  // scanning line + detected object
  drawLine();
  drawObject();
  
  // bottom overlay text
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null && data.length() > 1) {
    data = data.substring(0, data.length() - 1);
    index1 = data.indexOf(",");
    angle = data.substring(0, index1);
    distance = data.substring(index1 + 1);
    iAngle = int(angle);
    iDistance = int(distance);
  }
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height - height*0.074);
  arc(0, 0, width*0.94, width*0.94, PI, TWO_PI);
  arc(0, 0, width*0.73, width*0.73, PI, TWO_PI);
  arc(0, 0, width*0.52, width*0.52, PI, TWO_PI);
  arc(0, 0, width*0.31, width*0.31, PI, TWO_PI);
  line(-width/2, 0, width/2, 0);
  for (int a = 30; a <= 150; a += 30) {
    line(0, 0,
         -width/2 * cos(radians(a)),
         -width/2 * sin(radians(a)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width/2, height - height*0.074);
  line(0, 0,
       (height - height*0.12) * cos(radians(iAngle)),
       -(height - height*0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawObject() {
  if (iDistance < 40) {
    pushMatrix();
    translate(width/2, height - height*0.074);
    strokeWeight(9);
    stroke(255, 10, 10);
    pixsDistance = iDistance * ((height - height*0.1666) * 0.025);
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
         (width - width*0.505) * cos(radians(iAngle)), -(width - width*0.505) * sin(radians(iAngle)));
    popMatrix();
  }
}

void drawText() {
  // background panel
  fill(0);
  noStroke();
  rect(0, height - height*0.08, width, height*0.08);

  fill(98, 245, 31);
  textSize(height * 0.02);

  // static range markers
  text("10cm", width * 0.60, height * 0.92);
  text("20cm", width * 0.69, height * 0.92);
  text("30cm", width * 0.78, height * 0.92);
  text("40cm", width * 0.87, height * 0.92);

  // dynamic info
  textSize(height * 0.03);
  text("N_Tech",       width * 0.10, height * 0.97);
  text("Angle: " + iAngle + "°", width * 0.40, height * 0.97);

  String distStr = iDistance < 40 
    ? "Distance: " + iDistance + " cm" 
    : "Distance: Out of Range";
  text(distStr, width * 0.65, height * 0.97);
}
