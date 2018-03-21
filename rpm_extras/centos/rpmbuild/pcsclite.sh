#!/bin/bash
build_dependencies+=(
  ${centos7:+graphviz}
  ${centos6:+hal-devel}
  ${centos6:+libudev-devel}
  ${centos6:+libusb-devel}
  rpmdevtools
  ${centos7:+systemd-devel}
)
build_packages+=(pcsclite)

build_pcsclite () {
  local spec=specs/pcsc-lite${centos7:+-el7}.spec
  spectool -g -R ${spec}
  cp patches/pcsc-lite-*.patch ~/rpmbuild/SOURCES/
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/pcsc-lite-libs-*.rpm rpms/
}
