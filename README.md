# ghpi
GHPi connects temperature sensors to a Raspberry Pi for monitoring and logging.

# preparation
https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c
http://www.raspberrypi.org/forums/viewtopic.php?f=71&t=18852&p=188106&hilit=i2c+speed#p188106



# installation
sudo apt-get update

sudo apt-get install i2c-tools python-smbus python-pip python-dev

sudo pip install pillow


# enable i2c for oled

# install custom kernel or patch for 1-wire busses
