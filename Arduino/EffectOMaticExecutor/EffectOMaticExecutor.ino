// EffectOMaticExecutor

const int numberPins = 5;
const int pwnPins[] = {3, 5, 6, 9, 10};
char data[numberPins];

void setup()
{
  // initialize the serial communication:
  Serial.begin(9600);
  
  for(int i = 0; i < numberPins; i++)
  {
    pinMode(pwnPins[i], OUTPUT);
  }
}

void loop() {
  // check if data has been sent from the computer:
  if (Serial.available()) {
    Serial.readBytes(data, numberPins);

    for(int i = 0; i < numberPins; i++)
    {
      analogWrite(pwnPins[i], (byte)data[i]);
    }
  }
}
