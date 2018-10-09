#!/bin/bash
source_dependencies libassuan
add_rpmbuild_tasks build_gnupg_pkcs11_scd

add_packages \
  ${centos7:+libassuan-devel} \
  libgcrypt-devel \
  openssl-devel \
  pkcs11-helper-devel

build_gnupg_pkcs11_scd () {
  local uri=https://kojipkgs.fedoraproject.org/packages/gnupg-pkcs11-scd/0.9.1/3.fc28/src
  local pkg=gnupg-pkcs11-scd-0.9.1-3.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/gnupg-pkcs11-scd.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  build_centos6 && sed -i \
    -e 's|^%license|%{!?_licensedir:%global license %%doc}\n%license|' ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/gnupg-pkcs11-scd-0.*.rpm rpms/
}
