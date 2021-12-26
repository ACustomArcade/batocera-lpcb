#!/bin/bash
cd /tmp
curl -kLO /tmp/master.zip https://github.com/mholgatem/GPIOnext/archive/refs/heads/master.zip
unzip -q master.zip
mv GPIOnext-master/ /userdata/system/GPIOnext

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

/userdata/system/lpcb/init/gpionext-init.sh start

echo "GPIOnext installed!"

echo "Detecting Pixelcade..."
# let's detect if Pixelcade is connected
if ls /dev/ttyACM0 | grep -q '/dev/ttyACM0'; then
   echo "Pixelcade LED Marquee Detected!"
   echo "Running the Pixelcade installer..."
   bash <(curl -s https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/batocera_setup.sh)
else
   echo "Sorry, Pixelcade LED Marquee was not detected. If you have one, please ensure Pixelcade is USB connected to your Pi and the toggle switch on the Pixelcade board is pointing towards USB, exiting..."
fi
