#!/bin/bash
build_dependencies+=(
  texinfo
)
build_packages+=(libgpg_error)

build_libgpg_error () {
  local uri=https://kojipkgs.fedoraproject.org/packages/libgpg-error/1.27/5.fc28/src
  local pkg=libgpg-error-1.27-5.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/libgpg-error.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e 's|^%ldconfig|#%ldconfig|' ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/libgpg-error-1.*.rpm rpms/
  sudo yum install -y \
     ~/rpmbuild/RPMS/x86_64/libgpg-error-1.*.rpm \
     ~/rpmbuild/RPMS/x86_64/libgpg-error-devel-1.*.rpm
}
