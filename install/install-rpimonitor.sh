#!/bin/bash

# Cesta k instalacnim skriptum
[[ -z ${INSTALL_URL} ]] && INSTALL_URL="https://rxw.cz/adsb"

# Over prava na uzivatele root
[ -z ${SUDO} ] && SUDO=""
if [[ "$(id -u)" != "0" ]] && [[ ${SUDO} == "" ]];then
    echo "ERRROR: Instalaci je nutne spustit pod uzivatele root nebo z root pravy !"
    echo
    exit 3
fi

echo "* Instalace zavislosti"
echo "------------------------------------->"
$SUDO apt-get update
$SUDO apt-get install -y --no-install-suggests --no-install-recommends librrds-perl libhttp-daemon-perl libjson-perl libipc-sharelite-perl libfile-which-perl libsnmp-extension-passpersist-perl aptitude
#$SUDO apt-get install -y libwww-perl
#$SUDO apt --fix-broken install -y
echo "-------------------------------------<"

echo "* Stazeni programu RpiMonitor a jeho instalace"
RPIMONITOR_URL="https://github.com/XavierBerger/RPi-Monitor-deb/raw/develop/packages/rpimonitor_latest.deb"
wget ${RPIMONITOR_URL} -O rpimonitor_latest.deb
$SUDO dpkg -i rpimonitor_latest.deb

$SUDO /usr/share/rpimonitor/scripts/updatePackagesStatus.pl
$SUDO /etc/init.d/rpimonitor update
rm rpimonitor_latest.deb

echo "* Donastaveni RpiMonotru"
# Zobrazeni top3 aplikaci
$SUDO cp /usr/share/rpimonitor/web/addons/top3/top3.cron /etc/cron.d/top3
$SUDO sed -i 's/#web.status.1.content.1/web.status.1.content.1/g' /etc/rpimonitor/template/cpu*.conf
# Zobrazi status nastavenych sluzeb
$SUDO wget -q ${INSTALL_URL}/rpimonitor/czadsb_service.conf -O /etc/rpimonitor/template/czadsb_service.conf
if [[ $(grep "czadsb_service.conf" /etc/rpimonitor/data.conf | wc -l) -eq 0 ]];then
    $SUDO sh -c 'echo "include=/etc/rpimonitor/template/czadsb_service.conf" >> /etc/rpimonitor/data.conf'
fi
# Oprava nacitani teploty na Raspberry
$SUDO wget -q ${INSTALL_URL}/rpimonitor/temperature.conf -O /etc/rpimonitor/template/temperature.conf
# Pridej templejty
$SUDO wget -q ${INSTALL_URL}/rpimonitor/addons-piaware.conf -O /etc/rpimonitor/template/addons-piaware.conf
$SUDO wget -q ${INSTALL_URL}/rpimonitor/addons-ogn.conf     -O /etc/rpimonitor/template/addons-ogn.conf
$SUDO wget -q ${INSTALL_URL}/rpimonitor/addons-gps.conf     -O /etc/rpimonitor/template/addons-gps.conf
$SUDO wget -q ${INSTALL_URL}/rpimonitor/addons-glidertracker.conf -O /etc/rpimonitor/template/addons-glidertracker.conf
sleep 1
$SUDO systemctl restart rpimonitor.service

echo "* RpiMonitor je dostupny na IP "$(hostname -I)", port 8888."

