FROM alpine:latest AS build

ENV OPTIMIZATION="-O3"
ENV BUILD_DEPS="build-base linux-headers g++ make autoconf automake libtool pkgconf git wget bash"

ENV CFLAGS="${OPTIMIZATION}"
ENV CXXFLAGS="${OPTIMIZATION}"

RUN apk update && \
    apk add --update ${BUILD_DEPS}

RUN mkdir -p /build/src /build/obj /build/prefix

COPY developer_setup.sh /build
COPY src/ /build/src

WORKDIR /build

RUN ./developer_setup.sh \
    --build-target=dependencies \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --with-icu \
    --build-icu \
    --build-boost \
    --build-zmq

ENV BOOST_ROOT="/build/prefix"

RUN ./developer_setup.sh \
    --build-target=libbitcoin \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --enable-isystem \
    --without-consensus \
    --with-icu \
    --with-boost=/build/prefix

RUN ./developer_setup.sh \
    --build-target=project \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --enable-isystem \
    --without-consensus \
    --with-icu \
    --with-boost=/build/prefix

RUN rm -rf /build/src /build/obj



FROM alpine:latest AS runtime

ENV RUNTIME_DEPS="bash libstdc++"

RUN apk update && \
    apk add --update ${RUNTIME_DEPS}

COPY --from=build /build/prefix/bin/bs /bitcoin/bs
COPY bs-linux-startup.sh /bitcoin/startup.sh

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

WORKDIR /bitcoin
VOLUME ["/bitcoin/blockchain", "/bitcoin/conf"]
CMD [ "/bitcoin/startup.sh" ]
