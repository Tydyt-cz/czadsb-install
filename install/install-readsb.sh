#!/bin/bash
# Skript pro instalaci ReADSB (nahrazuje DUMP090) z deb balicku

# Instalace:
#   bash -c "$(wget -nv -O - https://rxw.cz/adsb/install/install-readsb.sh)"
#   wget https://rxw.cz/adsb/install/install-readsb.sh && chmod +x install-readsb.sh 

# Adresa deb balicku pro CzADSB
URL_DEB="https://rxw.cz/dists"

# Over prava na uzivatele root
[ -z ${SUDO} ] && SUDO=""
if [[ "$(id -u)" != "0" ]] && [[ ${SUDO} == "" ]];then
    echo "ERRROR: Instalaci je nutne spustit pod uzivatele root nebo z root pravy !"
    echo
    exit 3
fi

# Over zda nejde o upgrade, ale jen pokud je readsb install
if [[ ! -z ${UPGRADE}  &&  ${UPGRADE} && ! -z ${READSB} && "${READSB}" == "install" ]];then
    FORCE=true
else
    FORCE=false
fi

# Instalace Readsb, jen pokud jiz neexistuje nebo je force
if [ ! ${FORCE} ] &&  command -v readsb &>/dev/null ;then
    echo "Software ReADSB je na systemu jiz nainstalovan"
else
    # Nacti verzi systemu
    . /etc/os-release
    ARCH=$(dpkg --print-architecture)
    echo
    echo "Detekovan system: ${PRETTY_NAME} - ${ARCH}"
    echo
    # Uklid stare instalacni balicky
    $SUDO rm -f /tmp/readsb*
    # Stahni deb balicky pro konkretni architekturu
    WGET_URL="${URL_DEB}/${VERSION_CODENAME}/readsb_last_${ARCH}.deb"
    echo "* Ztahuji ${WGET_URL}"
    wget -nv -O /tmp/readsb.deb ${WGET_URL}
    if [ -f /tmp/readsb.deb ]; then
        echo
        echo "* Instaluji ReADSB klienta"
        $SUDO apt install -y /tmp/readsb.deb
    else
        echo
        echo "* ERROR:"
        echo "Pro Debian ${VERSION_CODENAME} ${ARCH} neni readsb k dispozici."
        echo "Prosim kontaktujte z touto informaci autora skriptu."
        exit 3
    fi
    echo "Mazu balicke readsb."
    rm -f /tmp/readsb*
fi

echo

