#!/bin/bash
source_dependencies repositories
add_tasks install_packages

add_packages () {
  add_items_to_list build_packages "$@"
}

install_packages () {
  yum install -y "${build_packages[@]}"
  yum update -y
}
