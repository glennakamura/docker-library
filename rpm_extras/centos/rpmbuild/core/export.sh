#!/bin/bash
export_references () {
  local _token
  for _token in $(declare "$@" | sed -e 's|[^A-Za-z0-9_]| |g'); do
    [[ "${_token}" == [a-z]* ]] || continue
    declare -p ${_token} &>/dev/null \
      && add_items_to_list _export_variables ${_token} \
      && export_references -p ${_token}
    declare -f ${_token} &>/dev/null \
      && add_items_to_list _export_functions ${_token} \
      && export_references -f ${_token}
  done
}

export_functions () {
  _export_variables=()
  _export_functions=("$@")
  export_references -f "$@"
  echo "$(declare -p "${_export_variables[@]}")"
  echo "$(declare -f "${_export_functions[@]}")"
  unset _export_variables _export_functions
}

export_tasks () {
  local _tasks="$1[@]"
  export_functions "${!_tasks}"
  echo "$(declare -F "${!_tasks}")"
}
