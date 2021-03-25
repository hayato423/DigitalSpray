#include "BluetoothSerial.h"
#define rpin 32
#define gpin 33
#define bpin 34
#define wpin 35

BluetoothSerial SerialBT;
const char *bt_name = "DigitalSplay";

void setup() {
  Serial.begin(115200);
  SerialBT.begin(bt_name);
}

void loop() {  
  int valr = analogRead(rpin)/16;
  int valg = analogRead(gpin)/16;
  int valb = analogRead(bpin)/16;
  int valw = analogRead(wpin)/16;
  SerialBT.print(valr);
  SerialBT.print(",");
  SerialBT.print(valg);
  SerialBT.print(",");
  SerialBT.print(valb);
  SerialBT.print(",");
  SerialBT.print(valw);
  SerialBT.print("\n");
  delay(100);
}
