#!/bin/bash

# Install PostgreSQL database
install_postgres () {
  local rhel=rhel-6-x86_64
  build_centos7 && rhel=rhel-7-x86_64
  curl -L -R -O \
    https://download.postgresql.org/pub/repos/yum/9.6/redhat/${rhel}/pgdg-redhat96-9.6-3.noarch.rpm
  yum install -y ./pgdg-redhat96-9.6-3.noarch.rpm
  yum install -y postgresql96-server postgresql96-devel postgresql-devel
  build_centos7 && sed -i -e '/^PGDATA=`/{:start
    s|^PGDATA=`.*`|PGDATA=/var/lib/pgsql/9.6/data/|
    t end;N;b start;:end}' /usr/pgsql-9.6/bin/postgresql96-setup
  local service=postgres_service${centos7:+_el7}
  ${service} initdb
  sed -i -e 's|^\(host.*\)ident$|\1md5|' /var/lib/pgsql/9.6/data/pg_hba.conf
  ${service} start
  su - postgres -c "psql -c \"ALTER ROLE postgres WITH PASSWORD 'password';\""
  ${service} stop
  build_services+=(${service})
}

postgres_service () {
  case "$1" in
    start)  service postgresql-9.6 start  ;;
    stop)   service postgresql-9.6 stop   ;;
    initdb) service postgresql-9.6 initdb ;;
  esac
}

postgres_service_el7 () {
  local pgdata=/var/lib/pgsql/9.6/data/
  local pid=${pgdata}/postmaster.pid
  case "$1" in
    start)
      su - postgres -s /bin/bash \
        -c "/usr/pgsql-9.6/bin/pg_ctl -D ${pgdata} start &>/dev/null"
      sleep 2
      ;;
    stop)
      [ -f ${pid} ] && kill $(head -n 1 ${pid})
      ;;
    initdb)
      /usr/pgsql-9.6/bin/postgresql96-setup initdb
      ;;
  esac
}
