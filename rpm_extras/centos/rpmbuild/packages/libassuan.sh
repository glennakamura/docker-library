#!/bin/bash
build_centos6 || return 0
build_package_dependencies libgpg_error
build_package libassuan || return 0

build_libassuan () {
  local uri=https://kojipkgs.fedoraproject.org/packages/libassuan/2.5.1/3.fc28/src
  local pkg=libassuan-2.5.1-3.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/libassuan.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e 's|^%ldconfig|#%ldconfig|' ${spec}
  build_centos6 && sed -i \
    -e 's|^%license|%{!?_licensedir:%global license %%doc}\n%license|' \
    -e 's|^%make_build|#%make_build|' ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/libassuan-2.*.rpm rpms/
  sudo yum install -y \
     ~/rpmbuild/RPMS/x86_64/libassuan-2.*.rpm \
     ~/rpmbuild/RPMS/x86_64/libassuan-devel-2.*.rpm
}
