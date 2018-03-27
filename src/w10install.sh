#!/bin/bash

sudo apt-get update &&
sudo apt-get -y install python &&
curl -L https://goo.gl/9tVe59 -o ~/crcl.sh &&
sudo chown "$USER":"$USER" ~/crcl.sh && sudo chmod +x ~/crcl.sh

grep "crcl.sh" ~/.bashrc
if [ $? = 1 ]; then
  echo 'echo Type ~/crcl.sh to start the creatinine calculator.' >> ~/.bashrc
fi

clear;
echo 'Complete! Type ~/crcl.sh to run the program and hit enter.'
echo 'In the future, click Start Menu > Ubuntu to open the creatinine calculator.'
