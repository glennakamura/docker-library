FROM alpine AS qemu

WORKDIR /tmp
RUN apk update && apk add alpine-sdk bash

RUN adduser -D -s /bin/bash build \
    && echo 'build ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/build \
    && chmod 711 /home/build

USER build
COPY qemu .
RUN ./build.sh

ENTRYPOINT ["/bin/bash"]

FROM scratch AS arm

COPY --from=qemu /tmp/root /
ENV QEMU_LD_PREFIX=/
SHELL ["/usr/bin/qemu-arm-static", "/bin/sh", "-c"]

RUN chmod 4111 /bin/bbsuid

ENTRYPOINT ["/usr/bin/qemu-arm-static", "/bin/sh"]
