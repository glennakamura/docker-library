#!/bin/bash
UBOOT_VERSION=odroidxu4-v2017.05
KERNEL_VERSION=odroidxu4-4.14.y
umask 022
mkdir -p odroid/root/boot
cd odroid

# compile u-boot
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
git clone --depth 1 --branch ${UBOOT_VERSION} \
  https://github.com/hardkernel/u-boot.git
cd u-boot
rm -rf .git
cat ../../u-boot-*.patch | patch -p1
make odroid-xu4_defconfig
make
cd ..

# compile kernel
export INSTALL_PATH=$(pwd)/root/boot
export INSTALL_MOD_PATH=$(pwd)/root
git clone --depth 1 --branch ${KERNEL_VERSION} \
  https://github.com/glennakamura/linux.git
cd linux
rm -rf .git
make odroidxu4_defconfig
make -j8 zImage modules dtbs
make zinstall
make modules_install
make dtbs_install
cd ..
