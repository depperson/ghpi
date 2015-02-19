/*
	GHPI
	RF24 Base Node for Raspberry Pi
	Daniel Epperson, 2014
*/

#include <cstdlib>
#include <iostream>
#include <sstream>
#include <string>
#include <RF24/RF24.h>

using namespace std;

// CE Pin, CSN Pin, SPI Speed
RF24 radio(RPI_V2_GPIO_P1_22, RPI_V2_GPIO_P1_24, BCM2835_SPI_SPEED_8MHZ);

// Radio pipe addresses for the 2 nodes to communicate.
const uint8_t pipes[][6] = {"1Node","2Node"};


int main(int argc, char** argv)
{
	char receivePayload[32];
	uint8_t len;
	uint8_t pipe = 1;

  	//printf("RF24RemoteTemp Server starting ...\n");

  	// setup rf24 radio
  	radio.begin();
  	radio.setRetries(15,15);
  	radio.openReadingPipe(1,pipes[1]);
  	radio.enableDynamicPayloads();
  	radio.setDataRate(RF24_250KBPS);
	radio.startListening();
  	//radio.printDetails();

	delay(1000);

	// forever loop
	while ( ! radio.available(&pipe))
	{
		//printf("waiting for data...\n");
		delay(1000);
	}

	len = radio.getDynamicPayloadSize();
	radio.read(receivePayload, len);
	cout << receivePayload << endl;
	
  	return 0;

} // end main()

