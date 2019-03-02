#!/bin/bash
set -e

if [ "${arch}" = x86 ] && [ -L /bin/uname ]; then
  rm -f /bin/uname
  echo $'#!/bin/sh\nexec linux32 busybox uname "$@"' >/bin/uname
  chmod 755 /bin/uname
fi

key=glennakamura.gitlab.io-5c27b806.rsa.pub
curl -L -R -o /etc/apk/keys/${key} \
  https://glennakamura.gitlab.io/alpine/keys/${key}
echo https://glennakamura.gitlab.io/alpine/testing >>/etc/apk/repositories

adduser -D -s /bin/bash build
addgroup build abuild
echo 'build ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/build
chmod 755 /home/build
su - build -c 'abuild-keygen -a -i'
