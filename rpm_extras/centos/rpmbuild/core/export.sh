#!/bin/bash
export_references () {
  local _token
  for _token in $(declare "$@" | sed -e 's|[^A-Za-z0-9_]| |g'); do
    [[ "${_token}" == [a-z]* ]] || continue
    declare -p ${_token} &>/dev/null \
      && add_items_to_list _build_export_variables ${_token} \
      && export_references -p ${_token}
    declare -f ${_token} &>/dev/null \
      && add_items_to_list _build_export_functions ${_token} \
      && export_references -f ${_token}
  done
}

export_tasks () {
  local _tasks="$1[@]"
  _build_export_variables=()
  _build_export_functions=("${!_tasks}")
  export_references -f "${!_tasks}"
  echo "$(declare -p "${_build_export_variables[@]}")"
  echo "$(declare -f "${_build_export_functions[@]}")"
  echo "$(declare -F "${!_tasks}")"
}
