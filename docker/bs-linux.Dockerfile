FROM alpine:latest AS build

ENV BUILD_DEPS="build-base linux-headers gcc make autoconf automake libtool pkgconf git wget bash"
ENV CPPFLAGS="-O3"

RUN apk update && \
    apk add --update ${BUILD_DEPS}

RUN mkdir -p /build/src /build/obj /build/prefix

COPY developer_setup.sh /build
COPY src/ /build/src
RUN /build/developer_setup.sh \
    --enable-isystem \
    --without-consensus \
    --with-icu \
    --build-icu \
    --build-boost \
    --build-zmq \
    --build-mode=configure \
    --build-target=all \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --disable-shared \
    --enable-static  && \
    rm -rf /build/src /build/obj



FROM alpine:latest AS runtime

COPY --from=build /build/prefix/bin/bs /bitcoin

# Bitcoin P2P
EXPOSE 8333/tcp
EXPOSE 8333/udp

# Query Service (Secure/Public)
EXPOSE 9081/tcp
EXPOSE 9091/tcp

# Heartbeat Service (Secure/Public)
EXPOSE 9082/tcp
EXPOSE 9092/tcp

# Block Service (Secure/Public)
EXPOSE 9083/tcp
EXPOSE 9093/tcp

# Transaction Service (Secure/Public)
EXPOSE 9084/tcp
EXPOSE 9094/tcp

VOLUME ["/bitcoin/data", "/bitcoin/conf"]
ENTRYPOINT ["/bitcoin/bs"]
CMD ["-c", "/bitcoin/conf/bs.cfg", "-i", "/bitcoin/data"]
