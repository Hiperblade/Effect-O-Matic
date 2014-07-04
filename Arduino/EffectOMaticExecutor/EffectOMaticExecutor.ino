// EffectOMaticExecutor

//const int pwnPins[] = {3, 5, 6, 9, 10, 11}; // Arduino UNO
//const int pwnPins[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}; // Arduino DUE / MEGA
const int pwnPins[] = {3, 5, 6, 9, 10};
const int digitalPins[] = {};

// soglia oltre la quale viene settato a HIGH il pin digitale
const int digitalThreshold = 200;

const int numberPwnPins = sizeof(pwnPins) / sizeof(int);
const int numberDigitalPins = sizeof(pwnPins) / sizeof(int);
const int numberPins = numberPwnPins + numberDigitalPins;
char data[numberPins];

void setup()
{
  // initialize the serial communication:
  Serial.begin(9600);
  
  for(int i = 0; i < numberPwnPins; i++)
  {
    pinMode(pwnPins[i], OUTPUT);
  }
  for(int i = 0; i < numberDigitalPins; i++)
  {  
    pinMode(digitalPins[i], OUTPUT);
  }
}

void loop()
{
  // check if data has been sent from the computer:
  if (Serial.available())
  {
    Serial.readBytes(data, numberPins);

    for(int i = 0; i < numberPins; i++)
    {
      if(i < numberPwnPins)
      {
        analogWrite(pwnPins[i], (byte)data[i]);
      }
      else
      {
        if((byte)data[i] > digitalThreshold)
        {
          digitalWrite(digitalPins[i - numberPwnPins], HIGH);
        }
        else
        {
          digitalWrite(digitalPins[i - numberPwnPins], LOW);
        }
      }
    }
  }
}
