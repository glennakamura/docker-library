#!/bin/bash
add_rpmbuild_tasks build_tmux

add_packages \
  libevent${centos6:+2}-devel \
  libutempter-devel \
  ncurses-devel

build_tmux () {
  local uri=https://kojipkgs.fedoraproject.org/packages/tmux/2.7/1.fc28/src
  local pkg=tmux-2.7-1.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/tmux.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  build_centos6 && sed -i \
    -e 's|libevent-devel|libevent2-devel|' \
    -e 's|^%make_build|#%make_build|' ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/tmux-2.*.rpm rpms/
}
