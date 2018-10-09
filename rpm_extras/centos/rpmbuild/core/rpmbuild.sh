#!/bin/bash
source_dependencies export
add_tasks \
  configure_rpmbuild \
  build_rpms

add_packages sudo

add_rpmbuild_tasks () {
  add_items_to_list rpmbuild_tasks "$@"
}

configure_rpmbuild () {
  build_centos7 && sed -i -e 's|\.el7\.centos|.el7|' /etc/rpm/macros.dist
  echo 'rpmbuild ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/rpmbuild
  install -d -m 755 -o rpmbuild -g rpmbuild /tmp/rpms
}

build_rpms () {
  su - rpmbuild -c "cd $(pwd); $(export_tasks rpmbuild_tasks)"
}
