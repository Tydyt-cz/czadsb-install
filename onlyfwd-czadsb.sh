#!/bin/bash
# Zjednoduseny instalacni skript z rucni konfiguraci kde jiz dump1090 bezi.
# Instaluje jen mlat-client z deb balicku a adsbfwd.
#
# Instalace:
#   bash -c "$(wget -nv -O - https://rxw.cz/adsb/onlyfwd-czadsb.sh)"

# Neco k nastaveni
URL_DEB="https://rxw.cz/dists"
MLAT_V="0.2.13"
SUDO="sudo"

# Nacti vybranou adresu
#URL_FWD="https://rxw.cz/adsb/install/install-adsbfwd.sh"
URL_FWD="https://raw.githubusercontent.com/CZADSB/czadsb-install/refs/heads/main/install/install-adsbfwd.sh"
#URL_FWD="https://raw.githubusercontent.com/Tydyt-cz/czadsb-install/refs/heads/main/install/install-adsbfwd.sh"

# Nacti verzi systemu
. /etc/os-release
ARCH=$(dpkg --print-architecture)
echo
echo "Detekovan system: ${PRETTY_NAME} - ${ARCH}"
echo

# Nainstaluj ADSBfwd a teprve pote mlat
echo
echo "* Stahuji a spoustim instalaci ADSBfwd"
wget -q ${URL_FWD} -O /tmp/install.tmp
. /tmp/install.tmp
rm -f /tmp/install.tmp

# Uklid stare instalacni balicky
$SUDO rm -f ./mlat-client*.deb
# Stahni deb balicky pro konkretni architekturu
WGET_URL="${URL_DEB}/${VERSION_CODENAME}/mlat-client_${MLAT_V}_${ARCH}.deb"
echo "* Ztahuji ${WGET_URL}"
wget -nv ${WGET_URL}

WGET_URL="${URL_DEB}/${VERSION_CODENAME}/mlat-client-dbgsym_${MLAT_V}_${ARCH}.deb"
echo "* Ztahuji ${WGET_URL}"
wget -nv ${WGET_URL}

if [ -f ./mlat-client_${MLAT_V}_${ARCH}.deb ] && [ -f ./mlat-client-dbgsym_${MLAT_V}_${ARCH}.deb ]; then
    echo
    echo "* Instaluji mlat klienta"
    $SUDO dpkg -i mlat-client*.deb
else
    echo
    echo "* ERROR:"
    echo "Pro Debian ${VERSION_CODENAME} ${ARCH} neni verze ${MLAT_V} k dispozici."
    echo "Prosim kontaktujte z touto informaci autora skriptu."
fi

echo
echo "Je nutne nakonfigurovat:"
echo " - /etc/default/mlat-client"
echo " - /etc/default/adsbfwd"

