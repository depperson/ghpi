#!/bin/bash
tce-load -wi apache2.4.tcz
tce-load -wi apache2.4-mod-php5.tcz

echo -n "Checking user..."
if [ "$(whoami)" != "root" ];
then
	echo "fail."
	echo "You must run this script as root."
	exit 1
fi
echo "done."

echo -n "Checking install path..."
if [ "$(pwd)" != "/opt/ghpi" ];
then
	echo "fail."
	echo "Move this folder to /opt/ghpi and run install.sh from there as root."
	exit 1
fi
echo "done."

echo -n "Checking apache2 startup..."
if [ "$(grep -c apachectl /opt/bootlocal.sh)" -ne 1 ];
then
	echo "# start apache" >> /opt/bootlocal.sh
	echo "/usr/local/sbin/apachectl start" >> /opt/bootlocal.sh
fi
echo "done"

echo -n "Checking i2c modules..."
if [ "$(lsmod|grep -c i2c)" -lt 2 ];
then
	echo "fail."
	echo "The i2c OLED display will not work. Proceeding anyway."
else
	echo "okay."
fi

echo -n "Checking /usr/local/apache2/htdocs symlink..."
if [ "$(ls -la /usr/local/apache2/htdocs | grep -c ghpi)" -ne 1 ];
then
	echo -n "missing. Creating symlink to /opt/ghpi/www. "
	rm -rf /usr/local/apache2/htdocs
	ln -sf /opt/ghpi/www/ /usr/local/apache2/htdocs
fi
echo "done."

echo "Saving filesystem changes..."
filetool.sh -b

