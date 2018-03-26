#!/bin/bash

# Install MySQL database
install_mysql () {
  local mysql57=mysql57-community-release-el6-11.noarch.rpm
  build_centos7 && mysql57=mysql57-community-release-el7-11.noarch.rpm
  curl -L -R -O https://dev.mysql.com/get/${mysql57}
  yum install -y ./${mysql57}
  yum install -y mysql-community-server mysql-community-devel
  local initd=/etc/init.d/mysqld
  build_centos7 && initd=/usr/bin/mysqld_pre_systemd
  sed -i -e "s|INSERT INTO mysql\\.plugin .*;|\
ALTER USER root@'localhost' IDENTIFIED BY '';|" ${initd}
  build_services+=(mysqld_service${centos7:+_el7})
}

mysqld_service () {
  case "$1" in
    start) service mysqld start ;;
    stop)  service mysqld stop  ;;
  esac
}

mysqld_service_el7 () {
  local pid=/var/run/mysqld/mysqld.pid
  case "$1" in
    start)
      /usr/bin/mysqld_pre_systemd
      su - mysql -s /bin/bash \
        -c "/usr/sbin/mysqld --daemonize --pid-file=${pid}"
      ;;
    stop)
      [ -f ${pid} ] && kill $(head -n 1 ${pid}) && sleep 2
      ;;
  esac
}
