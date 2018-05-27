#!/bin/bash
build_package tmux || return 0

build_dependencies+=(
  libevent${centos6:+2}-devel
  libutempter-devel
  ncurses-devel
)

build_tmux () {
  local uri=https://kojipkgs.fedoraproject.org/packages/tmux/2.6/3.fc28/src
  local pkg=tmux-2.6-3.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/tmux.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e "s|libevent-devel|libevent${centos6:+2}-devel|" ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/tmux-2.*.rpm rpms/
}
