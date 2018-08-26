#!/bin/bash
git clone -b master-alpine --depth 1 \
  https://github.com/glennakamura/buildroot.git

cd buildroot
cp -a "${arch}".config .config
make oldconfig
make

exit 0
