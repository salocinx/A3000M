#!/bin/bash
echo "*******************************************"
echo "* AMIGA 3000 MINI LED INSTALLATION SCRIPT *"
echo "*******************************************"
if [ "$(whoami)" != "root" ]; then
	echo " "
	echo "Sorry, you can't run this script with normal user privileges."
        echo "Call the script with super user privileges like this:"
        echo "sudo ./A3000M_LED_Install.sh"
	exit 1
fi
echo " "
echo " -> Which Raspberry Pi model do you use (1, 2, 3 or 4) ?"
read model
if [ "$model" = "1" ] || [ "$model" = "2" ] || [ "$model" = "3" ] || [ "$model" = "4" ]
    then
    	echo " "
    	echo " -> Going to update your operating system ..."
	echo " "
else
	echo " "
	echo "Script aborted. You need to provide a valid Raspberry Pi model (major version) -> 1, 2, 3 or 4."
	exit 1
fi
apt-get purge wiringpi
apt-get install git-core
apt-get update
apt-get upgrade
if [ "$model" = "1" ] || [ "$model" = "2" ] || [ "$model" = "3" ]
    then
    	echo " "
	echo " -> Going to install the WiringPi library ..."
	echo " "
	mkdir /tmp/WiringPi
	git clone https://github.com/WiringPi/WiringPi.git /tmp/WiringPi
	cd /tmp/WiringPi/
	./build
elif [ "$model" = "4" ]
    then
    	echo " "
	echo " -> Going to install the WiringPi library ..."
	echo " "
	cd /tmp
	wget https://project-downloads.drogon.net/wiringpi-latest.deb
	dpkg -i wiringpi-latest.deb
else
	echo " "
	echo "Script aborted. You need to provide a valid Raspberry Pi model (major version) -> 1, 2, 3 or 4."
	exit 1
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
echo " -> You need to restart your Raspberry Pi to make the LEDs work. Reboot now (Y=yes, n=no) ?"
read answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ] || [ "$answer" = "j" ] || [ "$answer" = "J" ]
    then
        reboot now
fi
