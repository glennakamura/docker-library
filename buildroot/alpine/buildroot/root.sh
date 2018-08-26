#!/bin/bash
set -e

adduser -D -s /bin/bash build
echo 'build ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/build
chmod 755 /home/build

if [ "${arch}" = x86 ]; then
  rm -f /bin/uname
  echo $'#!/bin/sh\nexec linux32 busybox uname "$@"' >/bin/uname
  chmod 755 /bin/uname
fi

chown build:build build.sh
su build -c ./build.sh
