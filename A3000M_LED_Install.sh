#!/bin/bash
echo "*******************************************"
echo "* AMIGA 3000 MINI LED INSTALLATION SCRIPT *"
echo "*******************************************"
echo " "
echo " -> Going to install the WiringPi library ..."
echo " "
apt-get purge wiringpi
apt-get install git-core
apt-get update
apt-get upgrade
mkdir /usr/lib/WiringPi
git clone https://github.com/WiringPi/WiringPi.git /usr/lib/WiringPi
cd /usr/lib/WiringPi/
./build
echo " "
echo " -> Going to install the PiLEDlights library ..."
echo " "
mkdir /usr/lib/PiLEDlights
git clone https://github.com/RagnarJensen/PiLEDlights.git /usr/lib/PiLEDlights
gcc -Wall -O3 -o /usr/lib/PiLEDlights/hddledPi /usr/lib/PiLEDlights/hddledPi.c -lwiringPi
gcc -Wall -O3 -o /usr/lib/PiLEDlights/netledPi /usr/lib/PiLEDlights/netledPi.c -lwiringPi
mv /usr/lib/PiLEDlights/hddledPi /usr/local/bin
mv /usr/lib/PiLEDlights/netledPi /usr/local/bin
cp /usr/lib/PiLEDlights/initscripts/systemd/*.service /etc/systemd/system
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
