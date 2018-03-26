#!/bin/bash
build_target=centos6
build_user=user
for argument in "$@"; do
  case "${argument}" in
    --target=centos[67]) build_target=${argument#*=} ;;
    --user=*)            build_user=${argument#*=}   ;;
  esac
done
eval ${build_target}=true  # centos6=true or centos7=true
build_centos6 () { ${centos6:-false}; }
build_centos7 () { ${centos7:-false}; }

build_dependencies=(bash-completion bzip2 man sudo vim)

source httpd.sh
source mysql.sh
source postgres.sh
source ruby.sh

# Enable man page installation
enable_man_pages () {
  sed -i -e 's|^\(tsflags=nodocs\)|# \1|' /etc/yum.conf
}

create_user_account () {
  local user=${build_user:-user}
  groupadd -g 500 ${user}
  useradd -u 500 -g ${user} ${user}
  echo "${user} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/admin
  cat <<EOF >>/home/${user}/.bashrc
umask 077
export TZ=/usr/share/zoneinfo/US/Hawaii
EOF
}

install_dependencies () {
  yum install -y epel-release
  yum install -y "${build_dependencies[@]}"
  yum update -y
  yum clean all
}

install_user_setup () {
  local user=${build_user:-user}
  local setup setup_functions
  for setup in "${build_user_setup[@]}"; do
    setup_functions+=("$(declare -f ${setup})")
  done
  local script=/home/${user}/.setup.sh
  IFS=$'\n'
  cat <<EOF >${script}
#!/bin/bash
${setup_functions[*]}
${build_user_setup[*]}
EOF
  unset IFS
  chown ${user}:${user} ${script}
  chmod 700 ${script}
}

install_entrypoint () {
  local service service_functions
  for service in "${build_services[@]}"; do
    service_functions+=("$(declare -f ${service})")
  done
  IFS=$'\n' service_functions="${service_functions[*]}"
  unset IFS
  cat <<EOF >/root/entrypoint.sh
#!/bin/bash
services='${build_services[*]}'
user='${build_user}'
${service_functions}
for service in \${services}; do
  \${service} start
done
if [ -x /home/\${user}/.setup.sh ]; then
  su - \${user} -c /home/\${user}/.setup.sh
  rm -f /home/\${user}/.setup.sh
fi
su - \${user}
for service in \${services}; do
  \${service} stop
done
EOF
  chmod 700 /root/entrypoint.sh
}

build_image () {
  enable_man_pages
  install_dependencies
  create_user_account
  install_httpd
  install_mysql
  install_postgres
  install_ruby
  install_user_setup
  install_entrypoint
}
build_image
