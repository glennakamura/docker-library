#!/bin/bash
build_dependencies+=(
  jemalloc-devel
  pandoc
)
build_packages+=(redis)

build_redis () {
  local uri=https://kojipkgs.fedoraproject.org/packages/redis/4.0.9/1.fc28/src
  local pkg=redis-4.0.9-1.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/redis.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/redis-4.*.rpm rpms/
}
