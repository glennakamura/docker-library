#!/bin/bash
add_tasks install_repositories

add_repository_tasks () {
  add_items_to_list build_repository_tasks "$@"
}

install_repositories () {
  execute_tasks build_repository_tasks
}
