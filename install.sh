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
	echo "Please move this folder to /opt/ghpi and run install.sh from there as root."
	exit 1
fi
echo "done."

echo -n "Checking i2c modules..."
if [ "$(lsmod|grep -c i2c)" -lt 2 ];
then
	echo "fail."
	echo "The i2c OLED display will not work. Proceeding anyway."
else
	echo "okay."
fi

echo -n "Checking /var/www symlink..."
if [ "$(ls -la /var | grep -c ghpi)" -ne 1 ];
then
	echo -n "missing. Creating symlink to /opt/ghpi/www. "
	rm -rf /var/www
	ln -sf /opt/ghpi/www/ /var/www
fi
echo "done."

echo -n "Checking /etc/rc.local symlink..."
if [ "$(ls -la /etc/rc.local | grep -c ghpi)" -ne 1 ];
then
	echo -n "missing. Creating symlink to /opt/ghpi/etc/rc.local. "
	rm -rf /etc/rc.local
	ln -sf /opt/ghpi/etc/rc.local /etc/rc.local
fi
echo "done."

echo -n "Checking /etc/sysctl.conf symlink..."
if [ "$(ls -la /etc/sysctl.conf | grep -c ghpi)" -ne 1 ];
then
	echo -n "missing. Creating symlink to /opt/ghpi/etc/sysctl.conf. "
	rm -rf /etc/sysctl.conf
	ln -sf /opt/ghpi/etc/sysctl.conf /etc/sysctl.conf
fi
echo "done."

echo -n "Checking /etc/cron.d/ghpi symlink..."
if [ "$(ls -la /etc/cron.d | grep -c ghpi)" -ne 1 ];
then
        echo -n "missing. Creating symlink to /opt/ghpi/etc/cron.d/ghpi. "
	ln -sf /opt/ghpi/etc/cron.d/ghpi /etc/cron.d/ghpi
fi
echo "done."

echo -n "Checking database /opt/ghpi/www/ghpi.db..."
if [ "$(ls -la /opt/ghpi/www | grep -c ghpi.db)" -ne 1 ];
then
        echo -n "missing. Creating empty db."
	/opt/ghpi/scripts/database.py init
fi
echo "done."

echo -n "Setting permissions on /opt/ghpi/www..."
chown www-data:www-data /opt/ghpi/www
echo "done."

echo -n "Creating temporary file /opt/ghpi/www/graphs/custom.png..."
touch /opt/ghpi/www/graphs/custom.png
chown www-data:www-data /opt/ghpi/www/graphs/custom.png
echo "done."

echo "Installing required software..."
apt-get install php5-sqlite i2c-tools python-smbus python-pip python-dev
pip install pillow
echo "done."


