#!/bin/bash

# Enable man page installation
sed -i -e 's|^\(tsflags=nodocs\)|# \1|' /etc/yum.conf

yum install -y \
  epel-release \
  gcc \
  man \
  sudo \
  vim

yum install -y \
  bash-completion \
  nodejs

# Install MySQL packages
curl -L -R -O \
  https://dev.mysql.com/get/mysql57-community-release-el6-11.noarch.rpm
yum install -y ./mysql57-community-release-el6-11.noarch.rpm
yum install -y mysql-community-server mysql-community-devel
sed -i -e "s|INSERT INTO mysql\\.plugin .*;|\
ALTER USER root@'localhost' IDENTIFIED BY '';|" /etc/init.d/mysqld

# Install PostgreSQL packages
curl -L -R -O \
  https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
yum install -y ./pgdg-redhat96-9.6-3.noarch.rpm
yum install -y postgresql96-server postgresql96-devel postgresql-devel
service postgresql-9.6 initdb
sed -i -e 's|^\(host.*\)ident$|\1md5|' /var/lib/pgsql/9.6/data/pg_hba.conf
service postgresql-9.6 start
su - postgres -c "psql -c \"ALTER ROLE postgres WITH PASSWORD 'password';\""
service postgresql-9.6 stop

# Install Apache packages
yum install -y httpd mod_ssl

# Update and clean yum cache
yum update -y
yum clean all

# Install chruby package
curl -L -R -O https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzf v0.3.9.tar.gz
(cd chruby-0.3.9; make install)

# Install ruby-install package
curl -L -R -O https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
tar -xzf v0.6.1.tar.gz
(cd ruby-install-0.6.1; make install)

# Install direnv package
curl -L -R -o /usr/local/bin/direnv \
  https://github.com/direnv/direnv/releases/download/v2.15.2/direnv.linux-amd64
chmod 755 /usr/local/bin/direnv

# Add user account
useradd rails
echo "rails ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/admin
cat <<EOF >>/home/rails/.bashrc
umask 077
source /usr/local/share/chruby/chruby.sh
eval \$(direnv hook bash)
EOF

# Install ruby packages
cat <<EOF >/tmp/user-build.sh
ruby-install ruby-2.4.2
ruby-install ruby-2.4.3
rm -rf ~/src
source /usr/local/share/chruby/chruby.sh
chruby 2.4.2
gem update --system
chruby 2.4.3
gem update --system
EOF
chmod 755 /tmp/user-build.sh
su - rails -c /tmp/user-build.sh
