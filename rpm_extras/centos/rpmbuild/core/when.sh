#!/bin/bash
match_list () {
  local list items item patterns pattern
  list="$1"; items="${list}[@]"
  shift
  set -f; patterns=($@); set +f
  for pattern in "${patterns[@]}"; do
    for item in "${!items}"; do
      [[ "${item}" == ${pattern} ]] && return 0 #true
    done
  done
  return 1 #false
}

match_role () {
  match_list build_roles "$@"
}

when () {
  while [ -n "$1" ]; do
    case "$1" in
      role=*)   match_role "${1#*=}" || return 1 ;;
      role!=*)  match_role "${1#*=}" && return 1 ;;
      *)        break ;;
    esac
    shift
  done
  "$@"
}
