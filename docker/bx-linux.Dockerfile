FROM alpine:latest AS build

ENV OPTIMIZATION="-O3"
ENV BUILD_DEPS="build-base linux-headers gcc make autoconf automake libtool pkgconf git wget bash"

ENV CFLAGS="${OPTIMIZATION}"
ENV CXXFLAGS="${OPTIMIZATION}"

RUN apk update && \
    apk add --update ${BUILD_DEPS}

RUN mkdir -p /build/src /build/obj /build/prefix

COPY developer_setup.sh /build
COPY src/ /build/src

RUN /build/developer_setup.sh \
    --build-target=dependencies \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --enable-isystem \
    --with-icu \
    --build-icu \
    --build-boost \
    --build-zmq

RUN /build/developer_setup.sh \
    --build-target=libbitcoin \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --enable-isystem \
    --with-icu \
    --build-icu \
    --build-boost \
    --build-zmq

RUN /build/developer_setup.sh \
    --build-target=project \
    --build-src-dir=/build/src \
    --build-obj-dir=/build/obj \
    --prefix=/build/prefix \
    --build-mode=configure \
    --disable-shared \
    --enable-static \
    --enable-isystem \
    --with-icu \
    --build-icu \
    --build-boost \
    --build-zmq \
    --without-tests

RUN rm -rf /build/src /build/obj



FROM alpine:latest AS runtime

ENV RUNTIME_DEPS="gcc"

RUN apk update && \
    apk add --update ${RUNTIME_DEPS}

COPY --from=build /build/prefix/bin/bx /bitcoin/bx

WORKDIR /bitcoin
ENTRYPOINT [ "/bitcoin/bx" ]
