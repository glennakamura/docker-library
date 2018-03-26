#!/bin/bash
build_dependencies+=(
  automake
  bison
  gcc
  gdbm-devel
  libffi-devel
  libyaml-devel
  ncurses-devel
  openssl-devel
  readline-devel
  zlib-devel
)

# Install chruby package
install_chruby () {
  curl -L -R -O https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
  tar -xzf v0.3.9.tar.gz
  (cd chruby-0.3.9; make install)
}

# Install ruby-install package
install_rubyinstall () {
  curl -L -R -O https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
  tar -xzf v0.6.1.tar.gz
  (cd ruby-install-0.6.1; make install)
}

# Install ruby packages
install_ruby () {
  install_chruby
  install_rubyinstall
  build_user_setup+=(ruby_user_setup)
}

ruby_user_setup () {
  local rubies='ruby-2.4.2 ruby-2.4.3'
  local ruby
  for ruby in ${rubies}; do
    ruby-install --no-install-deps ${ruby}
  done
  rm -rf ~/src
  source /usr/local/share/chruby/chruby.sh
  for ruby in ${rubies}; do
    chruby ${ruby}
    gem update --system
  done
  echo 'source /usr/local/share/chruby/chruby.sh' >>~/.bashrc
}
