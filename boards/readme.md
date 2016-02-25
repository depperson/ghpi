Both of these board designs have been manufactured by OSH Park, assembled and tested by myself. 


# GreenhousePi board (ghpi-board-r4.zip) 
This attaches four 1-wire networks, a Nordic RF24, and an I2C OLED display to a Raspberry Pi GPIO port. 
BOM:
- 6x 2p 3.5mm screw terminals
- 1x 2p 5mm screw terminals
- 1x Raspberry Pi GPIO female connector (2x18)
- 2x 4.7k 1/4w resistors
- 2x 10k 1/4w resistors
- 3x 4p .100 female row header


# GreenhousePi pinout
| rpi pin | gpio | purpose |
| ------- | ---- | ------- |
| 16      | 23   | 1-wire network A |
| 18      | 24   | 1-wire network B |
| 15      | 22   | 1-wire network C |
| 7       | 4    | 1-wire network D |
| 5       | 3    | OLED SCL |
| 3       | 2    | OLED SDA |
| 33      | 25   | nRF24 CE |
| 24      | 8    | nRF24 CSN |
| 23      | 11   | nRF24 SCK |
| 19      | 10   | nRF24 MOSI |
| 21      | 9    | nRF24 MISO |


# RF24Remote board (rf24remote-board-r3.zip)
This attaches two 1-wire networks and a Nordic RF24 to an Arduino Pro Micro 3.3v microcontroller. This package transmits temperature readings to the GreenhousePi board. 

BOM:
- 2x 4p .100 female row header
- 3x 2p 3.5mm screw terminals
- 1x 2p 5mm screw terminals
- 2x 4.7k 1/4w resistors
- 1x Arduino Pro Micro 3.3v


# RF24Remote pinout
| arduino pin | purpose |
| ----------- | ------- |



