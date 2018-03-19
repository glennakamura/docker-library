#!/bin/bash
if ${build_centos6}; then
  build_dependencies+=(
    hal-devel
    libudev-devel
    libusb-devel
    rpmdevtools
  )
  build_packages+=(pcsclite)
fi

build_pcsclite () {
  local spec=specs/pcsc-lite.spec
  spectool -g -R ${spec}
  cp patches/pcsc-lite-*.patch ~/rpmbuild/SOURCES/
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/pcsc-lite-libs-*.rpm rpms/
}
