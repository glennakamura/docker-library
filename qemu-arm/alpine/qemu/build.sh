#!/bin/bash
REPO=http://dl-cdn.alpinelinux.org/alpine/edge/main
VERSION=3.1.0

sudo apk add \
  alsa-lib-dev \
  bison \
  curl-dev \
  flex \
  glib-dev \
  glib-static \
  gnutls-dev \
  gtk+3.0-dev \
  libaio-dev \
  libcap-dev \
  libcap-ng-dev \
  libjpeg-turbo-dev \
  libnfs-dev \
  libpng-dev \
  libseccomp-dev \
  libssh2-dev \
  libusb-dev \
  libxml2-dev \
  linux-headers \
  lzo-dev \
  ncurses-dev \
  paxmark \
  python3 \
  sdl2-dev \
  snappy-dev \
  spice-dev \
  texinfo \
  usbredir-dev \
  util-linux-dev \
  vde2-dev \
  vte3-dev \
  xfsprogs-dev \
  xz \
  zlib-dev

umask 022
curl -L -R -O https://download.qemu.org/qemu-${VERSION}.tar.xz
tar xJf qemu-${VERSION}.tar.xz
cd qemu-${VERSION}
cat ../patches/*.patch | patch -p1
./configure \
  --disable-gnutls \
  --disable-system \
  --static \
  --target-list=arm-linux-user
make
strip --strip-unneeded arm-linux-user/qemu-arm
cd ..

curl -L -R -O ${REPO}/armhf/apk-tools-static-2.10.3-r0.apk
tar xzf apk-tools-static-2.10.3-r0.apk

sudo bash <<EOF
export QEMU_LD_PREFIX=/
mkdir -p root/usr/bin
install -m 755 -o root -g root \
  qemu-${VERSION}/arm-linux-user/qemu-arm \
  root/usr/bin/qemu-arm-static
./root/usr/bin/qemu-arm-static ./sbin/apk.static \
  -X ${REPO} -U --allow-untrusted --initdb --root ./root \
  add alpine-base
echo ${REPO} >root/etc/apk/repositories
EOF
