#!/bin/bash
wget https://github.com/mholgatem/GPIOnext/archive/refs/heads/master.zip
unzip master.zip
mv GPIOnext-master/ /userdata/system/GPIOnext
rm -f master.zip

curl -kLo /userdata/system/gpionext-init.sh https://raw.githubusercontent.com/ACustomArcade/batocera-lpcb/main/userdata/system/gpionext-init.sh
chmod +x /userdata/system/gpionext-init.sh
grep -qxF '/userdata/system/gpionext-init.sh $1' /userdata/system/custom.sh 2> /dev/null || echo '/userdata/system/gpionext-init.sh $1' >> /userdata/system/custom.sh

curl -kLo /userdata/system/GPIOnext/config/config.db https://github.com/ACustomArcade/batocera-lpcb/raw/main/userdata/system/GPIONext/config/config.db

echo "GPIOnext installed. Please reboot your system!"
