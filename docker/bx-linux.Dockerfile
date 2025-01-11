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
    --with-icu \
    --with-boost=/build/prefix \
    --without-tests

RUN rm -rf /build/src /build/obj



FROM alpine:latest AS runtime

ENV RUNTIME_DEPS="libstdc++"

RUN apk update && \
    apk add --update ${RUNTIME_DEPS}

COPY --from=build /build/prefix/bin/bx /bitcoin/bx

ENTRYPOINT [ "/bitcoin/bx" ]
