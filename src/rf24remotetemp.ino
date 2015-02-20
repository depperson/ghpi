/*
RF24 Remote Temperature Node for Arduino Pro Mini + NRF24  
Daniel Epperson, 2014
*/

#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"

#include <SPI.h>
#include <Narcoleptic.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// this gets transmitted
typedef struct {
  int addr;
  float temp;
} Reading;

// Data wire is plugged into pin 7 on the Arduino
#define ONE_WIRE_BUS 8
#define TEMPERATURE_PRECISION 9

// Setup a oneWire instance 
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
DeviceAddress onewire_addresses[10];
int sensorcount = 0;

// Hardware configuration: Set up nRF24L01 radio on SPI bus plus pins 9 & 10 
// ghpi rf24remote boards have ce and csn reversed
RF24 radio(10,9);

byte rf_addresses[][6] = {"1Node","2Node"};

// function to print a device address
String getAddr(DeviceAddress deviceAddress)
{
  String out = "";
  for (uint8_t i = 0; i < 8; i++)
  {
    // zero pad the address if necessary
    if (deviceAddress[i] < 16) out = out + "0";
    out = out + String(deviceAddress[i], HEX);
  }
  return out;
}

// function to print the temperature for a device
float getTempF(DeviceAddress deviceAddress)
{
  float tempC = sensors.getTempC(deviceAddress);
  return DallasTemperature::toFahrenheit(tempC);
}

// run once at startup
void setup() {
  
  Serial.begin(57600);
  printf_begin();
  printf("rF24RemoteTemp starting\n\r");

  printf("1-wire startup ... ");
  sensors.begin();
  Serial.print("found ");
  sensorcount = sensors.getDeviceCount();
  Serial.print(sensorcount, DEC);
  Serial.println(" devices.");  
  
  // find 1-wire slave addresses
  oneWire.reset_search();
  for (int devidx = 0; devidx < sensorcount; devidx++)
  {
    if (!oneWire.search(onewire_addresses[devidx])) 
    {
      Serial.print("Unable to find address for device ");
      Serial.println(devidx);
    } else {
      Serial.print("1-wire device ");
      Serial.print(devidx);
      Serial.print(" address ");
      Serial.print(getAddr(onewire_addresses[devidx]));
      Serial.println(" ");
      // configure sensor
      sensors.setResolution(onewire_addresses[devidx], TEMPERATURE_PRECISION);
    }
  }
  
  printf("RF24 radio startup ... \n\r");
  radio.begin();                          // Start up the radio
  radio.setAutoAck(1);                    // Ensure autoACK is enabled
  radio.setRetries(15,15);                // Max delay between retries & number of retries
  radio.openWritingPipe(rf_addresses[1]);
  radio.openReadingPipe(1, rf_addresses[0]);
  radio.enableDynamicPayloads();          // TODO: is this necessary?
  radio.setDataRate( RF24_250KBPS ) ;     // hopefully increase range
  radio.powerUp();
  radio.printDetails();                   // Dump the configuration of the rf unit for debugging
}


// main loop
void loop(void){
  if (sensorcount)
  {
    // update sensor array  
    sensors.requestTemperatures();    
    for (int devidx = 0; devidx < sensorcount; devidx++)
    {
      String output;
      char outbuf[31];
      char floatbuf[7];
      
      // wait for the sensor reply
      delay(2000);
          
      // build the output string as addr:temp.xx
      output = getAddr(onewire_addresses[devidx]);
      output += ":";
      float tempf = getTempF(onewire_addresses[devidx]);
      dtostrf(tempf, 3, 2, floatbuf);
      output = output + String(floatbuf);
      Serial.println(output);
      
      // transmit the data 
      output.toCharArray(outbuf, (output.length() + 1));
      radio.write(&outbuf, sizeof(outbuf));
      
      // sleep a bit
      Narcoleptic.delay(4000);
    }
    
  } else {
    // no sensors = ping mode (for range testing)
    int num = random(10000);
    String output = "ping" + String(num);
    char outbuf[31];
    char floatbuf[7];
    Serial.println(output);
    output.toCharArray(outbuf, (output.length() + 1));
    radio.write(&outbuf, sizeof(outbuf));
  }
  
  // sleep a bit more
  Narcoleptic.delay(6000);  
}
