#!/bin/bash
centos6_dependencies+=(
  libevent2-devel
  libutempter-devel
  ncurses-devel
)
build_packages+=(tmux)

build_tmux () {
  local uri=https://kojipkgs.fedoraproject.org/packages/tmux/2.6/3.fc28/src
  local pkg=tmux-2.6-3.fc28.src.rpm
  local spec=${HOME}/rpmbuild/SPECS/tmux.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e 's|libevent-devel|libevent2-devel|' ${spec}
  rpmbuild -bb ${spec}
  cp ${HOME}/rpmbuild/RPMS/x86_64/tmux-2.*.rpm rpms/
}
