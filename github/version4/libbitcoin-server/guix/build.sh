#!/bin/bash
###############################################################################
#  Copyright (c) 2014-2026 libbitcoin-server developers (see COPYING).
#  store_path, the cross search paths and the darwin compiler flags derive
#  from Bitcoin Core contrib/guix/libexec and depends/hosts/darwin.mk,
#  Copyright (c) The Bitcoin Core developers, MIT license
#  (https://opensource.org/license/mit).
###############################################################################
# Build one release binary inside the Guix container.
# environment: HOST, BASENAME, PROJECT, PROGRAM, FLAGS, LINKFLAGS, OPTIONS, JOBS
# darwin also: DEPLOYMENT_TARGET, with the SDK exposed at /sdk
# windows also: the MSVC and Windows SDK exposed at /winsdk
set -euo pipefail

export LC_ALL=C.UTF-8
export TZ=UTC
export HOME=/tmp
umask 0022

store_path()
{
    grep --extended-regexp "/[^-]{32}-${1}-[^-]+${2:+-${2}}" "${GUIX_ENVIRONMENT}/manifest" \
        | head --lines=1 \
        | sed --expression='s|\x29*$||' \
              --expression='s|^[[:space:]]*"||' \
              --expression='s|"[[:space:]]*$||'
}

dynamic_linker()
{
    case "${HOST}" in
        x86_64-linux-gnu)  echo /lib64/ld-linux-x86-64.so.2 ;;
        aarch64-linux-gnu) echo /lib/ld-linux-aarch64.so.1 ;;
        *) echo "Unsupported host '${HOST}'." >&2; exit 1 ;;
    esac
}

STORE_MAP="$(find /gnu/store -maxdepth 1 -mindepth 1 -type d -exec echo -n " -ffile-prefix-map={}=/usr" \;)"
DEBUG_FLAGS="-g -ffile-prefix-map=/distsrc=. -gno-record-gcc-switches${STORE_MAP}"

case "${HOST}" in
    *-linux-*)
        CROSS_GLIBC="$(store_path "glibc-cross-${HOST}")"
        CROSS_GLIBC_STATIC="$(store_path "glibc-cross-${HOST}" static)"
        CROSS_KERNEL="$(store_path "linux-libre-headers-cross-${HOST}")"
        CROSS_GCC="$(store_path "gcc-cross-${HOST}")"
        CROSS_GCC_LIB_STORE="$(store_path "gcc-cross-${HOST}" lib)"
        CROSS_GCC_LIBS=( "${CROSS_GCC_LIB_STORE}/lib/gcc/${HOST}"/* )
        CROSS_GCC_LIB="${CROSS_GCC_LIBS[0]}"

        export CROSS_C_INCLUDE_PATH="${CROSS_GCC_LIB}/include:${CROSS_GCC_LIB}/include-fixed:${CROSS_GLIBC}/include:${CROSS_KERNEL}/include"
        export CROSS_CPLUS_INCLUDE_PATH="${CROSS_GCC}/include/c++:${CROSS_GCC}/include/c++/${HOST}:${CROSS_GCC}/include/c++/backward:${CROSS_C_INCLUDE_PATH}"
        export CROSS_LIBRARY_PATH="${CROSS_GCC_LIB_STORE}/lib:${CROSS_GCC_LIB}:${CROSS_GLIBC}/lib:${CROSS_GLIBC_STATIC}/lib"
        export GUIX_LD_WRAPPER_DISABLE_RPATH=yes

        export CC="${HOST}-gcc"
        export CXX="${HOST}-g++"
        export CFLAGS="${FLAGS} ${DEBUG_FLAGS}"
        export CXXFLAGS="${CFLAGS}"
        export LDFLAGS="${LINKFLAGS} -Wl,--build-id -Wl,--dynamic-linker=$(dynamic_linker)"

        SYSTEM=(
            -DCMAKE_SYSTEM_NAME=Linux
            -DCMAKE_SYSTEM_PROCESSOR="${HOST%%-*}"
            -DCMAKE_C_STANDARD_LIBRARIES=-Wl,-lpthread,-ldl
            -DCMAKE_CXX_STANDARD_LIBRARIES=-Wl,-lpthread,-ldl )
        ;;
    *-apple-darwin)
        unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH OBJCPLUS_INCLUDE_PATH CPATH LIBRARY_PATH

        SDK_FLAGS="--target=${HOST} -mmacos-version-min=${DEPLOYMENT_TARGET} -mlinker-version=711 -isysroot/sdk -nostdlibinc"
        SDK_INCLUDES="-iwithsysroot/usr/include -iframeworkwithsysroot/System/Library/Frameworks"

        export CC=clang
        export CXX=clang++
        export CFLAGS="${SDK_FLAGS} ${SDK_INCLUDES} ${FLAGS} ${DEBUG_FLAGS}"
        export CXXFLAGS="${SDK_FLAGS} -iwithsysroot/usr/include/c++/v1 ${SDK_INCLUDES} -Xclang -fno-cxx-modules ${FLAGS} ${DEBUG_FLAGS}"
        export LDFLAGS="${SDK_FLAGS} ${LINKFLAGS} -fuse-ld=lld -Wl,-oso_prefix,/distsrc/"

        SYSTEM=(
            -DCMAKE_SYSTEM_NAME=Darwin
            -DCMAKE_SYSTEM_PROCESSOR="${HOST%%-*}"
            -DCMAKE_AR="$(command -v llvm-ar)"
            -DCMAKE_RANLIB="$(command -v llvm-ranlib)"
            -DCMAKE_INSTALL_NAME_TOOL="$(command -v llvm-install-name-tool)" )
        ;;
    *-pc-windows-msvc)
        unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH CPATH LIBRARY_PATH

        case "${HOST}" in
            x86_64-*)  ARCH=x64;   PROCESSOR=AMD64 ;;
            aarch64-*) ARCH=arm64; PROCESSOR=ARM64 ;;
        esac

        SDK_VERSION="$(ls /winsdk/sdk/Include)"
        SDK_INCLUDE="/winsdk/sdk/Include/${SDK_VERSION}"
        SDK_LIB="/winsdk/sdk/Lib/${SDK_VERSION}"
        OVERLAY=/tmp/winsdk.yaml
        {
            echo "version: 0"
            echo "case-sensitive: false"
            echo "roots:"
            find /winsdk -type f | sort | sed "s|.*|  - { name: '&', type: file, external-contents: '&' }|"
        } > "${OVERLAY}"

        CASED=/tmp/cased
        mkdir -p "${CASED}"
        find "${SDK_INCLUDE}" -type f | awk -F/ '{ print tolower($NF) "\t" $0 }' | sort > /tmp/headers
        grep -rhoE '^[[:space:]]*#[[:space:]]*include[[:space:]]*[<"][^<>"/]+[>"]' "${SDK_INCLUDE}" \
            | sed -E 's|.*[<"]([^<>"]+)[>"]|\1|' | sort -u \
            | awk '{ print tolower($0) "\t" $0 }' | sort > /tmp/includes
        join -t "$(printf '\t')" /tmp/includes /tmp/headers | while IFS="$(printf '\t')" read -r _ NAME FILE; do
            [[ "$(basename "${FILE}")" == "${NAME}" ]] || ln -sf "${FILE}" "${CASED}/${NAME}"
        done

        CL_MAP="$(echo " -ffile-prefix-map=/distsrc=.${STORE_MAP}" | sed 's| -| -clang:-|g')"

        export CC=clang-cl
        export CXX=clang-cl
        export CFLAGS="--target=${HOST} -vfsoverlay ${OVERLAY} -imsvc /winsdk/msvc/include -imsvc ${SDK_INCLUDE}/ucrt -imsvc ${SDK_INCLUDE}/um -imsvc ${SDK_INCLUDE}/shared -Brepro ${FLAGS} ${CL_MAP}"
        export CXXFLAGS="${CFLAGS}"
        export RCFLAGS="-I ${SDK_INCLUDE}/um -I ${SDK_INCLUDE}/shared -I ${CASED}"
        export LDFLAGS="-vfsoverlay:${OVERLAY} -libpath:/winsdk/msvc/lib/${ARCH} -libpath:${SDK_LIB}/ucrt/${ARCH} -libpath:${SDK_LIB}/um/${ARCH} -Brepro -debug:full -pdbaltpath:%_PDB% /MANIFEST:NO ${LINKFLAGS}"

        SYSTEM=(
            -DCMAKE_SYSTEM_NAME=Windows
            -DCMAKE_SYSTEM_VERSION=10.0
            -DCMAKE_SYSTEM_PROCESSOR="${PROCESSOR}"
            -DCMAKE_LINKER="$(command -v lld-link)"
            -DCMAKE_AR="$(command -v llvm-lib)"
            -DCMAKE_MT="$(command -v llvm-mt)"
            -DCMAKE_RC_COMPILER="$(command -v llvm-rc)"
            -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
            -DCMAKE_MSVC_DEBUG_INFORMATION_FORMAT=Embedded )
        ;;
    *)
        echo "Unsupported host '${HOST}'." >&2
        exit 1
        ;;
esac

bash "/distsrc/${PROJECT}/builds/cmake/install-cmake.sh" \
    "${SYSTEM[@]}" \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    --noninteractive \
    --build-use-local-src \
    --build-src-dir=/distsrc \
    --prefix=/distsrc/prefix \
    --build-obj-dir=obj \
    --build-obj-dir-relative \
    --build-config=release \
    --build-link=static \
    --build-skip-tests \
    --build-parallel="${JOBS}" \
    ${OPTIONS}

cd /output

case "${HOST}" in
    *-linux-*)
        BINARY="${BASENAME}"
        SYMBOLS="${BASENAME}.debug"
        cp "/distsrc/prefix/bin/${PROGRAM}" "${BINARY}"
        "${HOST}-objcopy" --only-keep-debug --compress-debug-sections=zlib "${BINARY}" "${SYMBOLS}"
        "${HOST}-strip" --strip-all "${BINARY}"
        "${HOST}-objcopy" --add-gnu-debuglink="${SYMBOLS}" "${BINARY}"
        ;;
    *-apple-darwin)
        BINARY="${BASENAME}"
        SYMBOLS="${BASENAME}.dSYM.zip"
        cp "/distsrc/prefix/bin/${PROGRAM}" "${BINARY}"
        dsymutil --oso-prepend-path=/distsrc "${BINARY}" -o "${BASENAME}.dSYM"
        llvm-strip -x "${BINARY}"
        find "${BASENAME}.dSYM" -exec touch --no-dereference --date=@946684800 {} +
        find "${BASENAME}.dSYM" | sort | zip -X -q "${SYMBOLS}" -@
        rm -rf "${BASENAME}.dSYM"
        ;;
    *-pc-windows-msvc)
        BINARY="${BASENAME}.exe"
        SYMBOLS="${BASENAME}.pdb.zip"
        cp "/distsrc/prefix/bin/${PROGRAM}.exe" "${BINARY}"
        cp "$(find /distsrc -path "*/obj/*" -name "${PROGRAM}.pdb" | head -1)" "${PROGRAM}.pdb"
        touch --date=@946684800 "${PROGRAM}.pdb"
        zip -X -q "${SYMBOLS}" "${PROGRAM}.pdb"
        rm "${PROGRAM}.pdb"
        ;;
esac

sha256sum "${BINARY}" "${SYMBOLS}" > SHA256SUMS
cat SHA256SUMS
