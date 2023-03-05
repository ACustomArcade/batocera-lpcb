#!/bin/bash
version=1  #increment this as the script is updated

if [[ -d "/userdata/system/lpcb" ]]; then
  if [[ -f "/userdata/system/lpcb/lpcb-version" ]]; then
    echo "Existing LPCB installation detected, checking version..."
    read -r currentVersion</userdata/system/lpcb/lpcb-version
    if [[ $currentVersion -lt $version ]]; then
      echo "Older LPCB version detected, now upgrading..."
      /userdata/system/lpcb/init/gpionext-init.sh stop
    fi
  else
    while true; do
      echo "Your existing LPCB installation will be deleted, do you want to re-install? (y/n): "
      read yn
      case $yn in
        [Yy]* ) /userdata/system/lpcb/init/gpionext-init.sh stop; rm -rf /userdata/system/lpcb; rm -rf /userdata/system/GPIOnext; break;;
        [Nn]* ) exit; break;;
        * ) echo "Please answer y or n";;
      esac
    done
  fi
fi

cd /tmp
curl -kLo /tmp/GPIOnext-master.zip https://github.com/mholgatem/GPIOnext/archive/refs/heads/master.zip
unzip -q /tmp/GPIOnext-master.zip
mv /tmp/GPIOnext-master /userdata/system/GPIOnext
rm -f /tmp/GPIOnext-master.zip

# cleanup old paths
sed -i '/\/userdata\/system\/gpionext-init.sh/d' /userdata/system/custom.sh
if [[ -f "/userdata/system/gpionext-init.sh" ]];  then
  rm /userdata/system/gpionext-init.sh
fi

mkdir -p /userdata/system/lpcb/init
curl -kLo /userdata/system/lpcb/init/gpionext-init.sh https://raw.githubusercontent.com/ACustomArcade/batocera-lpcb/main/userdata/system/gpionext-init.sh
chmod +x /userdata/system/lpcb/init/gpionext-init.sh
grep -qxF '/userdata/system/lpcb/init/gpionext-init.sh $1' /userdata/system/custom.sh 2> /dev/null || echo '/userdata/system/lpcb/init/gpionext-init.sh $1' >> /userdata/system/custom.sh

curl -kLo /userdata/system/GPIOnext/config/config.db https://github.com/ACustomArcade/batocera-lpcb/raw/main/userdata/system/GPIONext/config/config.db

echo 17 2>/dev/null > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio17/direction
echo "Detecting LPCB revision..."
echo "You will need to be in front of the ALU to continue."
echo
echo "Please hold down the Volume Down button on the ALU."
echo "DO NOT release the button until you are told!"
read -p "Press enter to read the buttons"
sleep 2
vol_down=$(cat /sys/class/gpio/gpio17/value)
echo "You may now release the Volume Down button."
read -p "Press enter to continue..."

if [[ "$vol_down" == "1" ]]; then
  echo "Swapping volume buttons in config database..."
  sqlite3 /userdata/system/GPIOnext/config/config.db "UPDATE 'GPIOnext' SET pins = '11' WHERE name = 'Volume Up'\;"
  sqlite3 /userdata/system/GPIOnext/config/config.db "UPDATE 'GPIOnext' SET pins = '13' WHERE name = 'Volume Down'\;"
fi

/userdata/system/lpcb/init/gpionext-init.sh start

echo "GPIOnext installed!"

echo "Detecting Pixelcade..."
# let's detect if Pixelcade is connected
if ls /dev/ttyACM0 | grep -q '/dev/ttyACM0'; then
   echo "Pixelcade LED Marquee Detected!"
   echo "Running the Pixelcade installer..."
   bash <(curl -s https://raw.githubusercontent.com/alinke/pixelcade-linux-builds/main/install-scripts/setup-batocera.sh)
else
   echo "Sorry, Pixelcade LED Marquee was not detected. If you have one, please ensure Pixelcade is USB connected to your Pi and the toggle switch on the Pixelcade board is pointing towards USB, exiting..."
fi

#let's write the version so the next time the user can try and know if they need to upgrade
echo $version > /userdata/system/lpcb/lpcb-version
