#!/bin/bash
case ${TARGET} in
  centos?) eval ${TARGET}=true ;; # centos6=true or centos7=true
esac
build_centos6=${centos6:-false}
build_centos7=${centos7:-false}

source git.sh
source pcsclite.sh
source tmux.sh

install_dependencies () {
  yum install -y "${build_dependencies[@]}"
  yum update -y
}

build_rpms () {
  mkdir rpms
  for pkg in "${build_packages[@]}"; do
    build_${pkg}
  done
}

if [ ${UID} = 0 ]; then
  install_dependencies
  su - rpmbuild -c "cd $(pwd) && TARGET=${TARGET} $0"
else
  build_rpms
fi
