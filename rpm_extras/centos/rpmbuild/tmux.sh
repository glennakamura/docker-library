#!/bin/bash
${build_centos6} && tmux_libevent_devel=libevent2-devel

build_dependencies+=(
  ${tmux_libevent_devel:=libevent-devel}
  libutempter-devel
  ncurses-devel
)
build_packages+=(tmux)

build_tmux () {
  local uri=https://kojipkgs.fedoraproject.org/packages/tmux/2.6/3.fc28/src
  local pkg=tmux-2.6-3.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/tmux.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e "s|libevent-devel|${tmux_libevent_devel}|" ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/tmux-2.*.rpm rpms/
}
