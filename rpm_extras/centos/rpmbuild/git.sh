#!/bin/bash
centos6_dependencies+=(
  acl
  asciidoc
  cvsps
  desktop-file-utils
  emacs
  expat-devel
  highlight
  httpd
  libcurl-devel
  mod_dav_svn
  openssl-devel
  pcre2-devel
  perl-CGI
  perl-DBD-SQLite
  perl-ExtUtils-MakeMaker
  perl-IO-Tty
  perl-MailTools
  perl-Test-Harness
  perl-Test-Simple
  perl-Time-HiRes
  python2-devel
  subversion-perl
  tcl
  time
  tk
  xmlto
  zlib-devel
)
build_packages+=(git)

build_git () {
  local uri=https://kojipkgs.fedoraproject.org/packages/git/2.16.2/1.fc28/src
  local pkg=git-2.16.2-1.fc28.src.rpm
  local spec=${HOME}/rpmbuild/SPECS/git.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  sed -i -e 's|^make test|#make test|' ${spec}
  rpmbuild -bb ${spec}
  cp ${HOME}/rpmbuild/RPMS/x86_64/git-2.*.rpm \
     ${HOME}/rpmbuild/RPMS/x86_64/git-core-2.*.rpm \
     ${HOME}/rpmbuild/RPMS/noarch/git-core-doc-2.*.rpm \
     ${HOME}/rpmbuild/RPMS/noarch/perl-Git-2.*.rpm \
    rpms/
}
