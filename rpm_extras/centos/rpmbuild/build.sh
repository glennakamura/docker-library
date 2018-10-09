#!/bin/bash
build_target=centos6
for argument in "$@"; do
  case "${argument}" in
    --target=centos[67]) build_target=${argument#*=} ;;
  esac
done
eval ${build_target}=true  # centos6=true or centos7=true
build_centos6 () { ${centos6:-false}; }
build_centos7 () { ${centos7:-false}; }

add_items_to_list () {
  local list items item item_to_add item_added=1 #false
  list="$1"; items="${list}[@]"
  shift
  for item_to_add in "$@"; do
    # skip if item_to_add already in list
    for item in "${!items}"; do
      [ "${item}" = "${item_to_add}" ] && continue 2
    done
    eval "${list}"+='("${item_to_add}")'
    item_added=0 #true
  done
  return ${item_added}
}

add_roles () {
  add_items_to_list build_roles "$@"
}

add_tasks () {
  add_items_to_list build_tasks "$@"
}

execute_tasks () {
  local task tasks="$1[@]"
  shift
  for task in "${!tasks}"; do
    ${task} "$@"
  done
}

source_dependencies () {
  local dependency file
  for dependency in "$@"; do
    file="${build_source_dir}/${dependency}.sh"
    [ -f "${file}" ] && source_file "${file}"
  done
}

source_file () {
  add_items_to_list build_source_files "$1" && source "$1"
}

source_dirs () {
  local dir file
  for dir in "$@"; do
    build_source_dir=$(cd "${dir}"; pwd)
    for file in "${build_source_dir}"/*.sh; do
      source_file "${file}"
    done
  done
}

source_dirs core packages
execute_tasks build_tasks
