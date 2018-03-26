#!/bin/bash
build_dependencies+=(httpd mod_ssl)

# Install Apache web server
install_httpd () {
  build_services+=(httpd_service${centos7:+_el7})
}

httpd_service () {
  case "$1" in
    start) service httpd start ;;
    stop)  service httpd stop  ;;
  esac
}

httpd_service_el7 () {
  local pid=/var/run/httpd/httpd.pid
  case "$1" in
    start) /usr/sbin/httpd ;;
    stop)  [ -f ${pid} ] && kill $(head -n 1 ${pid}) ;;
  esac
}
