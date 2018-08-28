#!/bin/bash
set -e

if [ "${arch}" = x86 ] && [ -L /bin/uname ]; then
  rm -f /bin/uname
  echo $'#!/bin/sh\nexec linux32 busybox uname "$@"' >/bin/uname
  chmod 755 /bin/uname
fi

adduser -D -s /bin/bash build
addgroup build abuild
echo 'build ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/build
chmod 755 /home/build
su - build -c "abuild-keygen -a -i"
