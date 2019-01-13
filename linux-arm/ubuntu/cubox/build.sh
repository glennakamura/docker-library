#!/bin/bash
UBOOT_VERSION=v2018.11
KERNEL_VERSION=4.19.14
umask 022
mkdir -p cubox/root/boot
cd cubox

# compile u-boot
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
git clone --depth 1 --branch ${UBOOT_VERSION} \
  git://git.denx.de/u-boot.git
cd u-boot
make mx6cuboxi_defconfig
make
cd ..

# compile kernel
export INSTALL_PATH=$(pwd)/root/boot
export INSTALL_MOD_PATH=$(pwd)/root
curl -L -R -O \
  https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz
tar xJf linux-${KERNEL_VERSION}.tar.xz
cd linux-${KERNEL_VERSION}
cat ../../kernel-*.patch | patch -p1
make imx_v6_v7_defconfig
make -j8 zImage modules dtbs
make zinstall
make modules_install
make dtbs_install
cd ..
