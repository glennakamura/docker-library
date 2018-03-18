#!/bin/bash
basedir=$(dirname "$0")
[ -f "${basedir}"/pcscd-key ] \
  || ssh-keygen -t rsa -f "${basedir}"/pcscd-key -N ''
docker image inspect pcscd &>/dev/null \
  || docker build -f "${basedir}"/Dockerfile.pcscd -t pcscd "${basedir}"
running=$(docker container inspect -f '{{.State.Running}}' pcscd 2>/dev/null) \
  || docker run -d --name pcscd -v pcscd:/var/run/docker-pcscd -p 2222:22 pcscd
[ "${running}" = 'false' ] && docker start pcscd
ssh-keygen -f "${HOME}"/.ssh/known_hosts -R [localhost]:2222 &>/dev/null
ssh -N -n -l pcscd -i "${basedir}"/pcscd-key -p 2222 \
  -R /var/run/docker-pcscd/pcscd.comm:/tmp/pcscd.comm \
  -o StrictHostKeyChecking=no localhost &>/dev/null &
