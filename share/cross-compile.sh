#!/bin/bash
####################################################################################################
# This file generates the binanries (and sha 256 checksums) for microcurrency core (microcurrency edition)
# from the https://github.com/satoshiware/microcurrency repository. This script was made for linux 
# x86 & ARM 64 bit and has been tested on Debian 11.
####################################################################################################

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Generated binaries and related files are transfered to the \"./microcurrency/bin\" directory."
echo "Binaries are created from the latest master branch commit @ https://github.com/satoshiware/microcurrency."
read -p "Press [Enter] key to continue..."

###Update/Upgrade
sudo apt-get -y update
sudo apt-get -y upgrade

###Install Essential Tools
sudo apt-get -y install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl zip
sudo apt-get -y install g++-aarch64-linux-gnu binutils-aarch64-linux-gnu #ARM 64-bit

###Install SQLite (Required For The Descriptor Wallet)
sudo apt-get -y install libsqlite3-dev

###Download Microcurrency
sudo apt-get -y install git
git clone --depth=1 --branch cleanup2 https://github.com/satoshiware/microcurrency ./microcurrency
cd microcurrency
rm -rf .git

###git checkout $COMMIT_HASH #Find the latest release at this link and its corresponding commit hash (7 digit code)

###Update, Add, or Overwrite microcurrency Header File: ./src/micro.h

###################################### x86 64 Bit ##############################################
###Prepare the Cross Compiler for "x86 64 Bit"
cd ./depends
sudo make clean
sudo make HOST=x86_64-pc-linux-gnu NO_TEST=1 NO_QT=1 NO_QR=1 NO_UPNP=1 NO_NATPMP=1 NO_BOOST=1 NO_LIBEVENT=1 NO_ZMQ=1 NO_USDT=1 -j $(($(nproc)+1)) #x86 64-bit

###Make Configuration
cd ..
./autogen.sh # Make sure Bash's current working directory is the microcurrency directory

### Select Configuration for "x86 64 Bit"
CONFIG_SITE=$PWD/depends/x86_64-pc-linux-gnu/share/config.site ./configure

###Compile /w All Available Cores & Install
make clean
make -j $(($(nproc)+1))

###Create Compressed Install Files in ./bin Directory
rm -rf ./mkinstall
rm -rf ./microcurrency-install
make install DESTDIR=$PWD/mkinstall
mv ./mkinstall/usr/local ./microcurrency-install
mkdir bin

###Compress Install Files for "x86 64 Bit"
tar -czvf ./bin/microcurrency-x86_64-linux-gnu.tar.gz ./microcurrency-install #x86 64-Bit

###################################### ARM 64 Bit ##############################################
###Prepare the Cross Compiler for "ARM 64 Bit"
cd ./depends
sudo make clean
sudo make HOST=aarch64-linux-gnu NO_QT=1 NO_QR=1 NO_UPNP=1 NO_NATPMP=1 NO_BOOST=1 NO_LIBEVENT=1 NO_ZMQ=1 NO_USDT=1 -j $(($(nproc)+1)) #ARM 64-bit

###Make Configuration
cd ..
./autogen.sh # Make sure Bash's current working directory is the microcurrency directory

### Select Configuration for "ARM 64 Bit"
CONFIG_SITE=$PWD/depends/aarch64-linux-gnu/share/config.site ./configure

###Compile /w All Available Cores & Install
make clean
make -j $(($(nproc)+1))

###Create Compressed Install Files in ./bin Directory
rm -rf ./mkinstall
rm -rf ./microcurrency-install
make install DESTDIR=$PWD/mkinstall
mv ./mkinstall/usr/local ./microcurrency-install
mkdir bin

###Compress Install Files for "ARM 64 Bit"
tar -czvf ./bin/microcurrency-aarch64-linux-gnu.tar.gz ./microcurrency-install #ARM 64-Bit

###################################### Calculate Hashes ##############################################
sha256sum ./bin/microcurrency-aarch64-linux-gnu.tar.gz > ./bin/SHA256SUMS
sha256sum ./bin/microcurrency-x86_64-linux-gnu.tar.gz >> ./bin/SHA256SUMS


#Well, renaiming this bad boy does not seem to be happening. What can we do?? I don't know.

