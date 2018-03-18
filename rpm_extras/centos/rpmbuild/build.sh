#!/bin/bash
source git.sh
source pcsclite.sh
source tmux.sh

install_devtools () {
  yum install -y epel-release
  yum groupinstall -y 'Development Tools'
  yum install -y "${centos6_dependencies[@]}"
  yum update -y
  useradd rpmbuild
  useradd mockbuild
}

build_rpms () {
  mkdir rpms
  for pkg in "${build_packages[@]}"; do
    build_${pkg}
  done
}

if [ ${UID} = 0 ]; then
  chmod 644 *.sh
  chmod 755 "$0"
  install_devtools
  su - rpmbuild -c "cd $(pwd) && $0"
else
  build_rpms
fi
