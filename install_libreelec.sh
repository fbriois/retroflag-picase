#!/bin/bash
echo "Downloading install script .... for LIBREELEC"
sleep 2
wget -q -O - https://raw.githubusercontent.com/fbriois/retroflag-picase/master/other_os/libreelec_install.sh | bash
