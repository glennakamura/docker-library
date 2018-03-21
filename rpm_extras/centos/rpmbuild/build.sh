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
  build_centos7 && sed -i -e 's|\.el7\.centos|.el7|' /etc/rpm/macros.dist
  install_dependencies
  su - rpmbuild -c "cd $(pwd) && $0 $*"
else
  build_rpms
fi
