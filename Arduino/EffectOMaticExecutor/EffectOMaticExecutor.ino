// EffectOMaticExecutor

//const int pwnPins[] = {3, 5, 6, 9, 10, 11}; // Arduino UNO
//const int pwnPins[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}; // Arduino DUE / MEGA
const int pwnPins[] = {3, 5, 6, 9, 10};

const int numberPins = sizeof(pwnPins) / sizeof(int);
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
