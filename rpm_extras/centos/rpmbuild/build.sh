#!/bin/bash
build_target=centos6
for argument in "$@"; do
  case "${argument}" in
    --target=centos[67]) build_target=${argument#*=} ;;
  esac
done
eval ${build_target}=true  # centos6=true or centos7=true
build_centos6 () { ${centos6:-false}; }
build_centos7 () { ${centos7:-false}; }

build_dependencies=(sudo)

build_package_dependencies () {
  local pkg
  for pkg in "$@"; do
    [ -f "packages/${pkg}.sh" ] && source "packages/${pkg}.sh"
  done
}

build_package () {
  local pkg
  for pkg in "${build_packages[@]}"; do
    [ "${pkg}" = "$1" ] && return 1
  done
  build_packages+=("$1")
}

source_packages () {
  local pkg
  for pkg in packages/*.sh; do
    source "${pkg}"
  done
}
source_packages

install_dependencies () {
  yum install -y "${build_dependencies[@]}"
  yum update -y
}

build_rpms () {
  local pkg
  mkdir rpms
  for pkg in "${build_packages[@]}"; do
    build_${pkg}
  done
}

if [ ${UID} = 0 ]; then
  install_dependencies
  build_centos7 && sed -i -e 's|\.el7\.centos|.el7|' /etc/rpm/macros.dist
  echo 'rpmbuild ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/rpmbuild
  su - rpmbuild -c "cd $(pwd) && $0 $*"
else
  build_rpms
fi
