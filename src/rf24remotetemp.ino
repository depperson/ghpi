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

// 1-wire busses on arduino D7 and D8 
#define ONE_WIRE_BUS_A 7
#define ONE_WIRE_BUS_B 8
#define TEMPERATURE_PRECISION 9

// Setup two oneWire instances
OneWire oneWireA(ONE_WIRE_BUS_A);
OneWire oneWireB(ONE_WIRE_BUS_B);
DallasTemperature sensorsA(&oneWireA);
DallasTemperature sensorsB(&oneWireB);
DeviceAddress onewire_addressesA[10];
DeviceAddress onewire_addressesB[10];
int sensorcountA = 0;
int sensorcountB = 0;

// Hardware configuration: Set up nRF24L01 radio on SPI bus plus pins 9 & 10 
// ghpi rf24remote boards have ce and csn reversed so use 10 & 9
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

  printf("1-wire A startup ... ");
  sensorsA.begin();
  Serial.print("found ");
  sensorcountA = sensorsA.getDeviceCount();
  Serial.print(sensorcountA, DEC);
  Serial.println(" devices.");  

  printf("1-wire B startup ... ");
  sensorsB.begin();
  Serial.print("found ");
  sensorcountB = sensorsB.getDeviceCount();
  Serial.print(sensorcountB, DEC);
  Serial.println(" devices.");  
  
  // find 1-wire A slave addresses
  oneWireA.reset_search();
  for (int devidx = 0; devidx < sensorcountA; devidx++)
  {
    if (!oneWireA.search(onewire_addressesA[devidx])) 
    {
      Serial.print("Unable to find address for device ");
      Serial.println(devidx);
    } else {
      Serial.print("1-wire device ");
      Serial.print(devidx);
      Serial.print(" address ");
      Serial.print(getAddr(onewire_addressesA[devidx]));
      Serial.println(" ");
      // configure sensors
      sensorsA.setResolution(onewire_addressesA[devidx], TEMPERATURE_PRECISION);
    }
  }

  // find 1-wire B slave addresses
  oneWireB.reset_search();
  for (int devidx = 0; devidx < sensorcountB; devidx++)
  {
    if (!oneWireB.search(onewire_addressesB[devidx])) 
    {
      Serial.print("Unable to find address for device ");
      Serial.println(devidx);
    } else {
      Serial.print("1-wire device ");
      Serial.print(devidx);
      Serial.print(" address ");
      Serial.print(getAddr(onewire_addressesB[devidx]));
      Serial.println(" ");
      // configure sensors
      sensorsA.setResolution(onewire_addressesB[devidx], TEMPERATURE_PRECISION);
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
  if (sensorcountA || sensorcountB)
  {
    // update 1-wire A 
    sensorsA.requestTemperatures();    
    for (int devidx = 0; devidx < sensorcountA; devidx++)
    {
      String output;
      char outbuf[31];
      char floatbuf[7];
      
      // wait for the sensor reply
      delay(2000);
          
      // build the output string as addr:temp.xx
      output = getAddr(onewire_addressesA[devidx]);
      output += ":";
      float tempC = sensorsA.getTempC(onewire_addressesA[devidx]);
      float tempf = DallasTemperature::toFahrenheit(tempC);
      dtostrf(tempf, 3, 2, floatbuf);
      output = output + String(floatbuf);
      Serial.println(output);
      
      // transmit the data 
      output.toCharArray(outbuf, (output.length() + 1));
      radio.write(&outbuf, sizeof(outbuf));
      
      // sleep a bit
      Narcoleptic.delay(4000);
    }
    
    // update 1-wire B
    sensorsB.requestTemperatures();    
    for (int devidx = 0; devidx < sensorcountB; devidx++)
    {
      String output;
      char outbuf[31];
      char floatbuf[7];
      
      // wait for the sensor reply
      delay(2000);
          
      // build the output string as addr:temp.xx
      output = getAddr(onewire_addressesB[devidx]);
      output += ":";
      float tempC = sensorsB.getTempC(onewire_addressesB[devidx]);
      float tempf = DallasTemperature::toFahrenheit(tempC);
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
