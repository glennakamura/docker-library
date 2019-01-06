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
cat <<EOF | patch -p1
--- a/include/configs/odroid_xu4.h
+++ b/include/configs/odroid_xu4.h
@@ -243,7 +243,7 @@
 	"copy_uboot_emmc2sd="UBOOT_COPY_EMMC2SD
 
 #undef CONFIG_BOOTCOMMAND
-#define CONFIG_BOOTCOMMAND "cfgload;movi r k 0 40008000;bootz 40008000"
+#define CONFIG_BOOTCOMMAND "cfgload;run distro_bootcmd;movi r k 0 40008000;bootz 40008000"
 
 #undef CONFIG_BOOTARGS
 /* Android Default bootargs */
EOF
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
