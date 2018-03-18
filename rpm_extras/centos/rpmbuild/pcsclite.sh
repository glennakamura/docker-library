#!/bin/bash
centos6_dependencies+=(
  hal-devel
  libudev-devel
  libusb-devel
  rpmdevtools
)
build_packages+=(pcsclite)

build_pcsclite () {
  local spec=specs/pcsc-lite.spec
  spectool -g -R ${spec}
  cp patches/pcsc-lite-*.patch ~/rpmbuild/SOURCES/
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/pcsc-lite-libs-*.rpm rpms/
}
