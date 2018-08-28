#!/bin/bash
set -e
arch=x86_64
for argument in "$@"; do
  case "${argument}" in
    --arch=*) arch=${argument#*=} ;;
  esac
done

docker build \
  -f Dockerfile.buildroot \
  -t buildroot-${arch} \
  --build-arg arch=${arch} .
