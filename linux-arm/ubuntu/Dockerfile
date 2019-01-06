FROM ubuntu:bionic

WORKDIR /tmp
RUN apt-get update && apt-get install -y \
  bc \
  bison \
  build-essential \
  curl \
  device-tree-compiler \
  flex \
  gcc-arm-linux-gnueabihf \
  git \
  kmod \
  libssl-dev \
  lzop \
  ncurses-dev
ARG target=cubox
RUN useradd -m ${target}

USER ${target}
COPY ${target} .
RUN ./build.sh
