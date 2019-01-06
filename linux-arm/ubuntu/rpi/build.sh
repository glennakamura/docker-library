#!/bin/bash
KERNEL_VERSION=rpi-4.19.y
umask 022
mkdir -p rpi/root/boot
cd rpi

# compile kernel
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export INSTALL_PATH=$(pwd)/root/boot
export INSTALL_MOD_PATH=$(pwd)/root
git clone --depth 1 --branch ${KERNEL_VERSION} \
  https://github.com/raspberrypi/linux.git
cd linux
rm -rf .git
cp -a . ../linux7
make bcmrpi_defconfig
make -j8 zImage modules dtbs
make zinstall
make modules_install
make dtbs_install
cd ../linux7
make bcm2709_defconfig
make -j8 zImage modules dtbs
make zinstall
make modules_install
make dtbs_install
cd ..
