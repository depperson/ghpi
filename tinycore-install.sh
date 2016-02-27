#!/bin/bash
tce-load -wi apache2.4.tcz
tce-load -wi apache2.4-mod-php5.tcz

echo -n "Checking apache2 startup..."
if [ "$(grep -c apachectl /opt/bootlocal.sh)" -ne 1 ];
then
	echo "# start apache" >> /opt/bootlocal.sh
	echo "/usr/local/sbin/apachectl start" >> /opt/bootlocal.sh
fi
echo "done"

echo "Saving filesystem changes..."
filetool.sh -b

