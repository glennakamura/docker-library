#!/bin/bash
build_package git || return 0

build_dependencies+=(
  ${centos6:+acl}
  asciidoc
  ${centos7:+bash-completion}
  ${centos7:+cvs}
  cvsps
  desktop-file-utils
  emacs
  expat-devel
  highlight
  httpd
  libcurl-devel
  ${centos7:+libsecret-devel}
  mod_dav_svn
  openssl-devel
  pcre2-devel
  perl-CGI
  perl-DBD-SQLite
  ${centos7:+perl-Digest-MD5}
  perl-ExtUtils-MakeMaker
  ${centos7:+perl-HTTP-Date}
  perl-IO-Tty
  perl-MailTools
  ${centos6:+perl-Test-Harness}
  perl-Test-Simple
  ${centos6:+perl-Time-HiRes}
  python2-devel
  subversion-perl
  tcl
  time
  tk
  xmlto
  zlib-devel
)

build_git () {
  local uri=https://kojipkgs.fedoraproject.org/packages/git/2.17.1/3.fc28/src
  local pkg=git-2.17.1-3.fc28.src.rpm
  local spec=~/rpmbuild/SPECS/git.spec
  curl -L -R -O ${uri}/${pkg}
  rpm -i ${pkg}
  build_centos6 && sed -i -e 's|^%make_build|make|' ${spec}
  sed -i -e 's|^make test|#make test|' ${spec}
  rpmbuild -bb ${spec}
  cp ~/rpmbuild/RPMS/x86_64/git-2.*.rpm \
     ~/rpmbuild/RPMS/x86_64/git-core-2.*.rpm \
     ~/rpmbuild/RPMS/noarch/git-core-doc-2.*.rpm \
     ~/rpmbuild/RPMS/noarch/perl-Git-2.*.rpm \
    rpms/
}
