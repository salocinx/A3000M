#!/bin/bash
echo "*******************************************"
echo "* AMIGA 3000 MINI LED INSTALLATION SCRIPT *"
echo "*******************************************"
echo " "
if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you can't run this script with normal user privileges."
        echo "Call the script with super user privileges like this:"
        echo "sudo ./A3000M_LED_Install.sh"
	exit 1
fi
echo " -> Which Raspberry Pi model are you using (1, 2, 3 or 4) ?"
read model
apt-get purge wiringpi
apt-get install git-core
apt-get update
apt-get upgrade
if [ "$model" = "4" ]
    then
    	echo " -> Going to install the WiringPi library ..."
	echo " "
        cd /tmp
	wget https://project-downloads.drogon.net/wiringpi-latest.deb
	dpkg -i wiringpi-latest.deb
    else
        echo " -> Going to install the WiringPi library ..."
	echo " "
	mkdir /tmp/WiringPi
	git clone https://github.com/WiringPi/WiringPi.git /tmp/WiringPi
	cd /tmp/WiringPi/
	./build
fi
echo " "
echo " -> Going to install the PiLEDlights library ..."
echo " "
mkdir /tmp/PiLEDlights
git clone https://github.com/RagnarJensen/PiLEDlights.git /tmp/PiLEDlights
gcc -Wall -O3 -o /tmp/PiLEDlights/hddledPi /tmp/PiLEDlights/hddledPi.c -lwiringPi
gcc -Wall -O3 -o /tmp/PiLEDlights/netledPi /tmp/PiLEDlights/netledPi.c -lwiringPi
mv /tmp/PiLEDlights/hddledPi /usr/local/bin
mv /tmp/PiLEDlights/netledPi /usr/local/bin
cp /tmp/PiLEDlights/initscripts/systemd/*.service /etc/systemd/system
systemctl daemon-reload
systemctl enable hddledPi.service
systemctl enable netledPi.service
echo " "
echo " -> You need to reboot your Raspberry Pi. Reboot now (Y=yes, n=no) ?"
read answer
if [ "$answer" = "Y" ]
    then
        reboot now
fi
