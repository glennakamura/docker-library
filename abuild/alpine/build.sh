#!/bin/bash
set -e
latest=3.9.0
version=${latest}
arch=x86_64
for argument in "$@"; do
  case "${argument}" in
    --version=*) version=${argument#*=} ;;
    --arch=*)    arch=${argument#*=}    ;;
  esac
done
baseuri=http://dl-cdn.alpinelinux.org/alpine/v${version%.*}/releases/${arch}
rootfs=alpine-minirootfs-${version}-${arch}.tar.gz

basedir=$(cd "$(dirname "$0")"; pwd)
sha256=$(grep ${rootfs} "${basedir}/sha256.txt" | cut -f1 -d\ )
sha512=$(grep ${rootfs} "${basedir}/sha512.txt" | cut -f1 -d\ )

[ -f ${rootfs} ] || curl --silent -L -R -O ${baseuri}/${rootfs}
sha256sum --quiet -c <(echo "${sha256}  ${rootfs}")
sha512sum --quiet -c <(echo "${sha512}  ${rootfs}")

docker build \
  -f Dockerfile.abuild \
  -t abuild-${arch}:${version} \
  --build-arg arch=${arch} \
  --build-arg rootfs=${rootfs} .

[ ${version} = ${latest} ] \
  && docker tag abuild-${arch}:${version} abuild-${arch}:latest
