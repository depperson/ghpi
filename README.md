# ghpi
GreenhousePi or GHPi connects temperature sensors to a Raspberry Pi for monitoring and logging.


# preparation
Install Raspbian Wheezy or earlier (Jessie expected to break due to new kernel)

https://downloads.raspberrypi.org/raspbian/images/raspbian-2015-05-07/2015-05-05-raspbian-wheezy.zip

Configure i2c for the OLED

https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c

http://www.raspberrypi.org/forums/viewtopic.php?f=71&t=18852&p=188106&hilit=i2c+speed#p188106



# installation
run ./install.sh


# install custom kernel or patch for 1-wire busses


# TODO:
- update the patched kernel
- cronjobs?
- sensor db


# Roadmap:
- pretty graphs / cloud hosted
- better mobile css
- tinycore linux
