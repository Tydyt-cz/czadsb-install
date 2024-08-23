# CzADSB - instalační skript

``Předmluva:``

Vzhledem k vývoji byl vytvořen nový pomocný instalační skript pro zdílení ADSB dat ze združením [https://czadsb.cz CzADSB]. 
Je testován pro nové verze Debian / Rasbian 11 a 12. Základní změny jsou:
* Konfigurační soubor je uložen v /etc/default/czadsb.cfg
* ModeMixer není funkční na nových verzích Debian. Proto skript jej již neinstaluje


``Instalace:``

Prvně si připravíme operační systém. Obecně při instalaci na Raspberry se doporučuje:
* Aktuální verze Raspbian 64 Bit Lite (nepředpokládám že na Rasbbery umístěné někde na půdě, či sožáru bude připojen monitor).
* Pokud chcete využívat MLAT data od FlightAware, tak použít jejich image [https://www.flightaware.com/adsb/piaware/build viz web].

Po zprovozní pak spustíme úprůvodce vlastni instalaci:
```
bash -c "$(wget -O - https://github.com/Tydyt-cz/czadsb-install/master/install-czadsb.sh)"
```
