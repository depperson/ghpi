#!/bin/bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Daniel Epperson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
# This installation script will hopefully install GHPi onto a vanilla Raspbian
# installation. It might delete or overwrite things in the process. 
#

echo -n "Checking install path..."
if [ "$(pwd)" != "/opt/ghpi" ];
then
	echo "fail."
	echo "Please move this folder to /opt/ghpi"
	exit 1
fi
echo "done."

echo -n "Checking i2c modules..."
if [ "$(lsmod|grep -c i2c)" -lt 2 ];
then
	echo "fail."
	echo "The i2c OLED display will not work. Proceeding anyway."
fi
echo "done."

echo -n "Checking /var/www symlink..."
if [ "$(ls -la /var | grep -c ghpi)" -ne 1 ];
then
	echo "fail. Creating symlink to /opt/ghpi/www. "
	rm -rf /var/www
	ln -sf /opt/ghpi/www/ /var/www
fi
echo "done."

echo -n "Checking /etc/rc.local symlink..."
if [ "$(ls -la /etc | grep -c ghpi)" -ne 1 ];
then
	echo "fail. Creating symlink to /opt/ghpi/etc/rc.local. "
	rm -rf /etc/rc.local
	ln -sf /opt/ghpi/etc/rc.local /etc/rc.local
fi
echo "done."

chown www-data:www-data /opt/ghpi/www

touch /opt/ghpi/www/graphs/custom.png
chown www-data:www-data /opt/ghpi/www/graphs/custom.png

