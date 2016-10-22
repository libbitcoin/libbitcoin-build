.template 0
###############################################################################
# Copyright (c) 2014-2016 libbitcoin developers (see COPYING).
#
# GSL generate install.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################  

# General repository query functions.

function have_build(install, name)
    define my.install = have_build.install
    return defined(my.install->build(starts_with(build.name, my.name)))
endfunction

function is_archive_match(build, name)
    define my.build = is_archive_match.build
    trace1("is_archive_match($(my.name)) : $(my.build.name)")
    return defined(my.build.version) & (my.build.name = my.name)
endfunction

function get_archive_version(install, name)
    trace1("get_archive_version($(my.name))")
    define my.install = get_archive_version.install
    define my.build = my.install->build(is_archive_match(build, my.name))?
    return defined(my.build) ?? my.build.version
endfunction

# Functions with specific knowledge of ICU archive file name and URL structure.

function get_icu_file(install)
    define my.install = get_icu_file.install
    define my.version = get_archive_version(my.install, "icu")?
    if (!defined(my.version))
        trace1("get_icu_file:get_archive_version() = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "icu4c-$(my.underscore_version)-src.tgz"
endfunction

function get_icu_url(install)
    trace1("get_icu_url()")
    define my.install = get_icu_url.install
    define my.version = get_archive_version(my.install, "icu")?
    if (!defined(my.version))
        trace1("get_icu_url:get_archive_version() = []")
        return
    endif
    define my.archive = get_icu_file(my.install)?
    if (!defined(my.archive))
        trace1("get_icu_url:get_icu_file() = []")
        return
    endif
    define my.base_url = "http\://download.icu-project.org/files/icu4c"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)"
    trace1("get_icu_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of ZLib archive file name and URL structure.

function get_zlib_file(install)
    define my.install = get_zlib_file.install
    define my.version = get_archive_version(my.install, "zlib")?
    if (!defined(my.version))
        trace1("get_zlib_file:get_archive_version() = []")
        return
    endif
    return "zlib-$(my.version).tar.xz"
endfunction

function get_zlib_url(install)
    trace1("get_zlib_url()")
    define my.install = get_zlib_url.install
    define my.version = get_archive_version(my.install, "zlib")?
    if (!defined(my.version))
        trace1("get_zlib_url:get_archive_version() = []")
        return
    endif
    define my.archive = get_zlib_file(my.install)?
    if (!defined(my.archive))
        trace1("get_zlib_url:get_zlib_file() = []")
        return
    endif
    define my.base_url = "http\://zlib.net"
    define my.url = "$(my.base_url)/$(my.archive)"
    trace1("get_zlib_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of PNG archive file name and URL structure.

function get_png_file(install)
    define my.install = get_png_file.install
    define my.version = get_archive_version(my.install, "png")?
    if (!defined(my.version))
        trace1("get_png_file:get_archive_version() = []")
        return
    endif
    return "libpng-$(my.version).tar.xz"
endfunction

function get_png_url(install)
    trace1("get_png_url()")
    define my.install = get_png_url.install
    define my.version = get_archive_version(my.install, "png")?
    if (!defined(my.version))
        trace1("get_png_url:get_archive_version() = []")
        return
    endif
    define my.archive = get_png_file(my.install)?
    if (!defined(my.archive))
        trace1("get_png_url:get_png_file() = []")
        return
    endif
    define my.base_url = "http://downloads.sourceforge.net/project/libpng/libpng16"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)"
    trace1("get_png_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of QREncode archive file name and URL structure.

function get_qrencode_file(install)
    define my.install = get_qrencode_file.install
    define my.version = get_archive_version(my.install, "qrencode")?
    if (!defined(my.version))
        trace1("get_qrencode_file:get_archive_version() = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "qrencode-$(my.version).tar.bz2"
endfunction

function get_qrencode_url(install)
    trace1("get_qrencode_url()")
    define my.install = get_qrencode_url.install
    define my.version = get_archive_version(my.install, "qrencode")?
    if (!defined(my.version))
        trace1("get_qrencode_url:get_archive_version() = []")
        return
    endif
    define my.archive = get_qrencode_file(my.install)?
    if (!defined(my.archive))
        trace1("get_qrencode_url:get_qrencode_file() = []")
        return
    endif
    define my.base_url = "http\://fukuchi.org/works/qrencode"
    define my.url = "$(my.base_url)/$(my.archive)"
    trace1("get_qrencode_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of Boost archive file name and URL structure.

function get_boost_file(install)
    define my.install = get_boost_file.install
    define my.version = get_archive_version(my.install, "boost")?
    if (!defined(my.version))
        trace1("get_boost_file:get_archive_version() = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "boost_$(my.underscore_version).tar.bz2"
endfunction

function get_boost_url(install)
    trace1("get_boost_url()")
    define my.install = get_boost_url.install
    define my.version = get_archive_version(my.install, "boost")?
    if (!defined(my.version))
        trace1("get_boost_url:get_archive_version()) = []")
        return
    endif
    define my.archive = get_boost_file(my.install)?
    if (!defined(my.archive))
        trace1("get_boost_url:get_boost_file() = []")
        return
    endif
    define my.base_url = "http\://downloads.sourceforge.net/project/boost/boost"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)"
    trace1("get_boost_url = $(my.url)")
    return my.url
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro install_documentation(repository)
.   define my.repo = install_documentation.repository
# Script to build and install $(my.repo.name).
#
# Script options:
.   if (have_build(my.repo->install, "icu"))
# --build-icu              Builds ICU libraries.
.   endif
.   if (have_build(my.repo->install, "zlib"))
# --build-zlib             Builds ZLib libraries.
.   endif
.   if (have_build(my.repo->install, "png"))
# --build-png              Builds PNG libraries.
.   endif
.   if (have_build(my.repo->install, "qrencode"))
# --build-qrencode         Builds QREncode libraries.
.   endif
.   if (have_build(my.repo->install, "boost"))
# --build-boost            Builds Boost libraries.
.   endif
# --build-dir=<path>       Location of downloaded and intermediate files.
# --prefix=<absolute-path> Library install location (defaults to /usr/local).
# --disable-shared         Disables shared library builds.
# --disable-static         Disables static library builds.
#
# Verified on Ubuntu 14.04, requires gcc-4.8 or newer.
# Verified on OSX 10.10, using MacPorts and Homebrew repositories, requires
# Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn) or newer.
# This script does not like spaces in the --prefix or --build-dir, sorry.
# Values (e.g. yes|no) in the '--disable-<linkage>' options are not supported.
# All command line options are passed to 'configure' of each repo, with
# the exception of the --build-<item> options, which are for the script only.
# Depending on the caller's permission to the --prefix or --build-dir
# directory, the script may need to be sudo'd.
.endmacro # install_documentation
.
.macro define_build_directory(repository)
.   define my.repo = define_build_directory.repository
.   heading2("The default build directory.")
BUILD_DIR="build-$(my.repo.name)"

.endmacro # define_build_directory
.
.macro define_object_directory(repository)
.   heading2("The default object directory.")
OBJECT_DIR="bin-objects"

.endmacro #define_object_directory

.macro define_icu(install)
.   define my.install = define_icu.install
.   define my.url = get_icu_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of icu is not defined."
.       return
.   endif
.   heading2("ICU archive.")
ICU_URL="$(my.url)"
ICU_ARCHIVE="$(get_icu_file(my.install))"

.endmacro # define_icu
.
.macro define_zlib(install)
.   define my.install = define_zlib.install
.   define my.url = get_zlib_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of zlib is not defined."
.       return
.   endif
.   heading2("ZLib archive.")
ZLIB_URL="$(my.url)"
ZLIB_ARCHIVE="$(get_zlib_file(my.install))"

.endmacro # define_zlib
.
.macro define_png(install)
.   define my.install = define_png.install
.   define my.url = get_png_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of png is not defined."
.       return
.   endif
.   heading2("PNG archive.")
PNG_URL="$(my.url)"
PNG_ARCHIVE="$(get_png_file(my.install))"

.endmacro # define_png
.
.macro define_qrencode(install)
.   define my.install = define_qrencode.install
.   define my.url = get_qrencode_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of qrencode is not defined."
.       return
.   endif
.   heading2("QREncode archive.")
QRENCODE_URL="$(my.url)"
QRENCODE_ARCHIVE="$(get_qrencode_file(my.install))"

.endmacro # define_qrencode
.
.macro define_boost(install)
.   define my.install = define_boost.install
.   define my.url = get_boost_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of boost is not defined."
.       return
.   endif
.   heading2("Boost archive.")
BOOST_URL="$(my.url)"
BOOST_ARCHIVE="$(get_boost_file(my.install))"

.endmacro # define_boost
.
.macro define_initialize()
.   heading2("Exit this script on the first build error.")
set -e

.   heading2("Configure build parallelism.")
SEQUENTIAL=1
OS=`uname -s`
if [[ $PARALLEL ]]; then
    echo "Using shell-defined PARALLEL value."
elif [[ $TRAVIS == true ]]; then
    PARALLEL=$SEQUENTIAL
elif [[ $OS == Linux ]]; then
    PARALLEL=`nproc`
elif [[ ($OS == Darwin) || ($OS == OpenBSD) ]]; then
    PARALLEL=`sysctl -n hw.ncpu`
else
    echo "Unsupported system: $OS"
    exit 1
fi

.   heading2("Define operating system specific settings.")
if [[ $OS == Darwin ]]; then
    export CC="clang"
    export CXX="clang++"
    STDLIB="c++"
elif [[ $OS == OpenBSD ]]; then
    make() { gmake "$@"; }
    export CC="egcc"
    export CXX="eg++"
    STDLIB="estdc++"
else # Linux
    STDLIB="stdc++"
fi

.   heading2("Link to appropriate standard library in non-default scnearios.")
if [[ ($OS == Linux && $CC == "clang") || ($OS == OpenBSD) ]]; then
    export LDLIBS="-l$STDLIB $LDLIBS"
    export CXXFLAGS="-stdlib=lib$STDLIB $CXXFLAGS"
fi

.   heading2("Parse command line options that are handled by this script.")
for OPTION in "$@"; do
    case $OPTION in
        # Custom build options (in the form of --build-<option>).
        (--build-icu)      BUILD_ICU="yes";;
        (--build-zlib)     BUILD_ZLIB="yes";;
        (--build-png)      BUILD_PNG="yes";;
        (--build-qrencode) BUILD_QRENCODE="yes";;
        (--build-boost)    BUILD_BOOST="yes";;
        (--build-dir=*)    BUILD_DIR="${OPTION#*=}";;

        # Standard build options.
        (--prefix=*)       PREFIX="${OPTION#*=}";;
        (--disable-shared) DISABLE_SHARED="yes";;
        (--disable-static) DISABLE_STATIC="yes";;
        (--with-icu)       WITH_ICU="yes";;
        (--with-png)       WITH_PNG="yes";;
        (--with-qrencode)  WITH_QRENCODE="yes";;
    esac
done

.   heading2("Normalize of static and shared options.")
if [[ $DISABLE_SHARED ]]; then
    CONFIGURE_OPTIONS=("$@" "--enable-static")
elif [[ $DISABLE_STATIC ]]; then
    CONFIGURE_OPTIONS=("$@" "--enable-shared")
else
    CONFIGURE_OPTIONS=("$@" "--enable-shared")
    CONFIGURE_OPTIONS=("$@" "--enable-static")
fi

.   heading2("Purge custom build options so they don't break configure.")
CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--build-*/}")

.   heading2("Always set a prefix (required on OSX and for lib detection).")
if [[ !($PREFIX) ]]; then
    PREFIX="/usr/local"
    CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]}" "--prefix=$PREFIX")
else
    # Incorporate the custom libdir into each object, for runtime resolution.
    export LD_RUN_PATH="$PREFIX/lib"
fi

.   heading2("Incorporate the prefix.")
# Set the prefix-based package config directory.
PREFIX_PKG_CONFIG_DIR="$PREFIX/lib/pkgconfig"

# Augment PKG_CONFIG_PATH search path with our prefix.
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$PREFIX_PKG_CONFIG_DIR"

# Set a package config save path that can be passed via our builds.
with_pkgconfigdir="--with-pkgconfigdir=$PREFIX_PKG_CONFIG_DIR"

if [[ $BUILD_BOOST ]]; then
    # Boost has no pkg-config, m4 searches in the following order:
    # --with-boost=<path>, /usr, /usr/local, /opt, /opt/local, $BOOST_ROOT.
    # We use --with-boost to prioritize the --prefix path when we build it.
    # Otherwise standard paths suffice for Linux, Homebrew and MacPorts.
    # ax_boost_base.m4 appends /include and adds to BOOST_CPPFLAGS
    # ax_boost_base.m4 searches for /lib /lib64 and adds to BOOST_LDFLAGS
    with_boost="--with-boost=$PREFIX"
fi

.   heading2("Echo generated values.")
echo "Libbitcoin installer configuration."
echo "--------------------------------------------------------------------"
echo "OS                    : $OS"
echo "PARALLEL              : $PARALLEL"
echo "CC                    : $CC"
echo "CXX                   : $CXX"
echo "CPPFLAGS              : $CPPFLAGS"
echo "CFLAGS                : $CFLAGS"
echo "CXXFLAGS              : $CXXFLAGS"
echo "LDFLAGS               : $LDFLAGS"
echo "LDLIBS                : $LDLIBS"
echo "WITH_ICU              : $WITH_ICU"
echo "WITH_PNG              : $WITH_PNG"
echo "WITH_QRENCODE         : $WITH_QRENCODE"
echo "BUILD_ICU             : $BUILD_ICU"
echo "BUILD_ZLIB            : $BUILD_ZLIB"
echo "BUILD_PNG             : $BUILD_PNG"
echo "BUILD_QRENCODE        : $BUILD_QRENCODE"
echo "BUILD_BOOST           : $BUILD_BOOST"
echo "PREFIX                : $PREFIX"
echo "BUILD_DIR             : $BUILD_DIR"
echo "DISABLE_SHARED        : $DISABLE_SHARED"
echo "DISABLE_STATIC        : $DISABLE_STATIC"
echo "with_boost            : ${with_boost}"
echo "with_pkgconfigdir     : ${with_pkgconfigdir}"
echo "--------------------------------------------------------------------"

.endmacro # define_initialize
.
.macro define_build_options(build)
.   define my.build = define_build_options.build
.   heading2("Define $(my.build.name) options.")
$(my.build.name:upper,c)_OPTIONS=(
.   for my.build.option as _option
"$(_option.value)"$(last() ?? ")" ? " \\")
.   endfor _option

.endmacro # define_build_options
.
.macro define_utility_functions()
.
configure_options()
{
    echo "configure options:"
    for OPTION in "$@"; do
        if [[ $OPTION ]]; then
            echo $OPTION
        fi
    done

    ./configure "$@"
}

configure_options_object_dir()
{
    echo "configure options:"
    for OPTION in "$@"; do
        if [[ $OPTION ]]; then
            echo $OPTION
        fi
    done

    ../configure "$@"
}

configure_links()
{
    # Configure dynamic linker run-time bindings when installing to system.
    if [[ ($OS == Linux) && ($PREFIX == "/usr/local") ]]; then
        ldconfig
    fi
}

create_directory()
{
    local DIRECTORY="$1"

    rm -rf "$DIRECTORY"
    mkdir "$DIRECTORY"
}

display_message()
{
    local MESSAGE="$1"

    echo
    echo "********************** $MESSAGE **********************"
    echo
}

initialize_git()
{
    # Initialize git repository at the root of the current directory.
    git init
    git config user.name anonymous
}

# make_current_directory jobs [configure_options]
make_current_directory()
{
    local JOBS=$1
    shift 1

    create_directory "$OBJECT_DIR"
    ./autogen.sh
    push_directory "$OBJECT_DIR"
    configure_options_object_dir "$@"
    make_jobs $JOBS
    make install
    configure_links
    pop_directory
}

# make_jobs jobs [make_options]
make_jobs()
{
    local JOBS=$1
    shift 1

    # Avoid setting -j1 (causes problems on Travis).
    if [[ $JOBS > $SEQUENTIAL ]]; then
        make -j$JOBS "$@"
    else
        make "$@"
    fi
}

# make_tests jobs
make_tests()
{
    local JOBS=$1

    # Disable exit on error.
    set +e

    # Build and run unit tests relative to the primary directory.
    # VERBOSE=1 ensures test runner output sent to console (gcc).
    make_jobs $JOBS check "VERBOSE=1"
    local RESULT=$?

    # Test runners emit to the test.log file.
    if [[ -e "test.log" ]]; then
        cat "test.log"
    fi

    if [[ $RESULT -ne 0 ]]; then
        exit $RESULT
    fi

    # Reenable exit on error.
    set -e
}

pop_directory()
{
    popd >/dev/null
}

push_directory()
{
    local DIRECTORY="$1"

    pushd "$DIRECTORY" >/dev/null
}

.endmacro # define_utility_functions
.
.macro define_build_functions()
.

# Because PKG_CONFIG_PATH doesn't get updated by Homebrew or MacPorts.
initialize_icu_packages()
{
    if [[ ($OS == Darwin) ]]; then
        # Update PKG_CONFIG_PATH for ICU package installations on OSX.
        # OSX provides libicucore.dylib with no pkgconfig and doesn't support
        # renaming or important features, so we can't use that.
        local HOMEBREW_ICU_PKG_CONFIG="/usr/local/opt/icu4c/lib/pkgconfig"
        local MACPORTS_ICU_PKG_CONFIG="/opt/local/lib/pkgconfig"

        if [[ -d "$HOMEBREW_ICU_PKG_CONFIG" ]]; then
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$HOMEBREW_ICU_PKG_CONFIG"
        elif [[ -d "$MACPORTS_ICU_PKG_CONFIG" ]]; then
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$MACPORTS_ICU_PKG_CONFIG"
        fi
    fi
}

# Because ZLIB doesn't actually parse its --disable-shared option.
# Because ZLIB doesn't follow GNU recommentation for unknown arguments.
patch_zlib_configuration()
{
    sed -i.tmp "s/leave 1/shift/" configure
    sed -i.tmp "s/--static/--static | --disable-shared/" configure
    sed -i.tmp "/unknown option/d" configure
    sed -i.tmp "/help for help/d" configure

    # echo "Hack: ZLIB configuration options modified."
}

# Because ZLIB can't build shared only.
clean_zlib_build()
{
    if [[ $DISABLE_STATIC ]]; then
        rm --force "$PREFIX/lib/libz.a"
    fi
}

# Standard build from tarball.
build_from_tarball()
{
    local URL=$1
    local ARCHIVE=$2
    local COMPRESSION=$3
    local PUSH_DIR=$4
    local JOBS=$5
    local BUILD=$6
    local OPTIONS=$7
    shift 7

    # For some platforms we need to set ICU pkg-config path.
    if [[ !($BUILD) ]]; then
        if [[ $ARCHIVE == $ICU_ARCHIVE ]]; then
            initialize_icu_packages
        fi
        return
    fi

    # Because libpng doesn't actually use pkg-config to locate zlib.
    # Because ICU tools don't know how to locate internal dependencies.
    if [[ ($ARCHIVE == $ICU_ARCHIVE) || ($ARCHIVE == $PNG_ARCHIVE) ]]; then
        local SAVE_LDFLAGS=$LDFLAGS
        export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
    fi

    # Because libpng doesn't actually use pkg-config to locate zlib.h.
    if [[ ($ARCHIVE == $PNG_ARCHIVE) ]]; then
        local SAVE_CPPFLAGS=$CPPFLAGS
        export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
    fi

    display_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory $EXTRACT
    push_directory $EXTRACT

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --$COMPRESSION --strip-components=1
    push_directory $PUSH_DIR

    # Enable static only zlib build.
    if [[ $ARCHIVE == $ZLIB_ARCHIVE ]]; then
        patch_zlib_configuration
    fi

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    configure_options "${CONFIGURATION[@]}"
    make_jobs $JOBS --silent
    make install
    configure_links

    # Enable shared only zlib build.
    if [[ $ARCHIVE == $ZLIB_ARCHIVE ]]; then
        clean_zlib_build
    fi

    pop_directory
    pop_directory

    # Restore flags to prevent side effects.
    export LDFLAGS=$SAVE_LDFLAGS
    export CPPFLAGS=$SAVE_LCPPFLAGS

    pop_directory
}

# Because boost ICU detection assumes in incorrect ICU path.
circumvent_boost_icu_detection()
{
    # Boost expects a directory structure for ICU which is incorrect.
    # Boost ICU discovery fails when using prefix, can't fix with -sICU_LINK,
    # so we rewrite the two 'has_icu_test.cpp' files to always return success.

    local SUCCESS="int main() { return 0; }"
    local REGEX_TEST="libs/regex/build/has_icu_test.cpp"
    local LOCALE_TEST="libs/locale/build/has_icu_test.cpp"

    echo $SUCCESS > $REGEX_TEST
    echo $SUCCESS > $LOCALE_TEST

    # echo "Hack: ICU detection modified, will always indicate found."
}

# Because boost doesn't support autoconfig and doesn't like empty settings.
initialize_boost_configuration()
{
    if [[ $DISABLE_STATIC ]]; then
        BOOST_LINK="shared"
    elif [[ $DISABLE_SHARED ]]; then
        BOOST_LINK="static"
    else
        BOOST_LINK="static,shared"
    fi

    if [[ $CC ]]; then
        BOOST_TOOLSET="toolset=$CC"
    fi

    if [[ ($OS == Linux && $CC == "clang") || ($OS == OpenBSD) ]]; then
        STDLIB_FLAG="-stdlib=lib$STDLIB"
        BOOST_CXXFLAGS="cxxflags=$STDLIB_FLAG"
        BOOST_LINKFLAGS="linkflags=$STDLIB_FLAG"
    fi
}

# Because boost doesn't use pkg-config.
initialize_boost_icu_configuration()
{
    BOOST_ICU_ICONV="on"
    BOOST_ICU_POSIX="on"

    if [[ $WITH_ICU ]]; then
        circumvent_boost_icu_detection

        # Restrict other locale options when compiling boost with icu.
        BOOST_ICU_ICONV="off"
        BOOST_ICU_POSIX="off"

        # Extract ICU libs from package config variables and augment with -ldl.
        ICU_LIBS=( `pkg-config icu-i18n --libs` "-ldl" )

        # This is a hack for boost m4 scripts that fail with ICU dependency.
        # See custom edits in ax-boost-locale.m4 and ax_boost_regex.m4.
        export BOOST_ICU_LIBS="${ICU_LIBS[@]}"

        # Extract ICU prefix directory from package config variable.
        ICU_PREFIX=`pkg-config icu-i18n --variable=prefix`
    fi
}

# Because boost doesn't use autoconfig.
build_from_tarball_boost()
{
    local URL=$1
    local ARCHIVE=$2
    local COMPRESSION=$3
    local PUSH_DIR=$4
    local JOBS=$5
    local BUILD=$6
    shift 6

    if [[ !($BUILD) ]]; then
        return
    fi

    display_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory $EXTRACT
    push_directory $EXTRACT

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --$COMPRESSION --strip-components=1

    initialize_boost_configuration
    initialize_boost_icu_configuration

    echo "Libbitcoin boost configuration."
    echo "--------------------------------------------------------------------"
    echo "variant               : release"
    echo "threading             : multi"
    echo "toolset               : $CC"
    echo "cxxflags              : $STDLIB_FLAG"
    echo "linkflags             : $STDLIB_FLAG"
    echo "link                  : $BOOST_LINK"
    echo "boost.locale.iconv    : $BOOST_ICU_ICONV"
    echo "boost.locale.posix    : $BOOST_ICU_POSIX"
    echo "-sNO_BZIP2            : 1" 
    echo "-sICU_PATH            : $ICU_PREFIX"
    echo "-sICU_LINK            : ${ICU_LIBS[@]}"
    echo "-sZLIB_LIBPATH        : $PREFIX/lib"
    echo "-sZLIB_INCLUDE        : $PREFIX/include"
    echo "-j                    : $JOBS"
    echo "-d0                   : [supress informational messages]"
    echo "-q                    : [stop at the first error]"
    echo "--reconfigure         : [ignore cached configuration]"
    echo "--prefix              : $PREFIX"
    echo "BOOST_OPTIONS         : $@"
    echo "--------------------------------------------------------------------"

    # boost_iostreams
    # The zlib options prevent boost linkage to system libs in the case where
    # we have built zlib in a prefix dir. Disabling zlib in boost is broken in
    # all versions (through 1.60). https://svn.boost.org/trac/boost/ticket/9156
    # The bzip2 auto-detection is not implemented, but disabling it works.

    ./bootstrap.sh \\
        "--prefix=$PREFIX" \\
        "--with-icu=$ICU_PREFIX"

    ./b2 install \\
        "variant=release" \\
        "threading=multi" \\
        "$BOOST_TOOLSET" \\
        "$BOOST_CXXFLAGS" \\
        "$BOOST_LINKFLAGS" \\
        "link=$BOOST_LINK" \\
        "boost.locale.iconv=$BOOST_ICU_ICONV" \\
        "boost.locale.posix=$BOOST_ICU_POSIX" \\
        "-sNO_BZIP2=1" \\
        "-sICU_PATH=$ICU_PREFIX" \\
        "-sICU_LINK=${ICU_LIBS[@]}" \\
        "-sZLIB_LIBPATH=$PREFIX/lib" \\
        "-sZLIB_INCLUDE=$PREFIX/include" \\
        "-j $JOBS" \\
        "-d0" \\
        "-q" \\
        "--reconfigure" \\
        "--prefix=$PREFIX" \\
        "$@"

    pop_directory
    pop_directory
}

# Standard build from github.
build_from_github()
{
    push_directory "$BUILD_DIR"

    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    local JOBS=$4
    local OPTIONS=$5
    shift 5

    FORK="$ACCOUNT/$REPO"
    display_message "Download $FORK/$BRANCH"

    # Clone the repository locally.
    git clone --branch $BRANCH --single-branch "https://github.com/$FORK"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    # Build the local repository clone.
    push_directory $REPO
    make_current_directory $JOBS "${CONFIGURATION[@]}"
    pop_directory
    pop_directory
}

# Standard build of current directory.
build_from_local()
{
    local MESSAGE="$1"
    local JOBS=$2
    local OPTIONS=$3
    shift 3

    display_message "$MESSAGE"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    # Build the current directory.
    make_current_directory $JOBS "${CONFIGURATION[@]}"
}

# Because Travis alread has downloaded the primary repo.
build_from_travis()
{
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    local JOBS=$4
    local OPTIONS=$5
    shift 5

    # The primary build is not downloaded if we are running in Travis.
    if [[ $TRAVIS == true ]]; then
        build_from_local "Local $TRAVIS_REPO_SLUG" $JOBS "${OPTIONS[@]}" "$@"
        push_directory "$OBJECT_DIR"
        make_tests $JOBS
        pop_directory
    else
        build_from_github $ACCOUNT $REPO $BRANCH $JOBS "${OPTIONS[@]}" "$@"
        push_directory $REPO
        make_tests $JOBS
        pop_directory
    fi
}

.endmacro # define_build_functions
.
.macro build_from_tarball_icu()
    build_from_tarball $ICU_URL $ICU_ARCHIVE gzip source $PARALLEL "$BUILD_ICU" "${ICU_OPTIONS[@]}" "$@"
.endmacro # build_icu
.
.macro build_from_tarball_zlib()
    build_from_tarball $ZLIB_URL $ZLIB_ARCHIVE xz . $PARALLEL "$BUILD_ZLIB" "${ZLIB_OPTIONS[@]}" "$@"
.endmacro # build_zlib
.
.macro build_from_tarball_png()
    build_from_tarball $PNG_URL $PNG_ARCHIVE xz . $PARALLEL "$BUILD_PNG" "${PNG_OPTIONS[@]}" "$@"
.endmacro # build_png
.
.macro build_from_tarball_qrencode()
    build_from_tarball $QRENCODE_URL $QRENCODE_ARCHIVE bzip2 . $PARALLEL "$BUILD_QRENCODE" "${QRENCODE_OPTIONS[@]}" "$@"
.endmacro # build_qrencode
.
.macro build_boost()
    build_from_tarball_boost $BOOST_URL $BOOST_ARCHIVE bzip2 . $PARALLEL "$BUILD_BOOST" "${BOOST_OPTIONS[@]}"
.endmacro # build_boost
.
.macro build_github(build)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    build_from_github $(my.build.github) $(my.build.repository) $(my.build.branch) $(my.parallel) $(my.options) "$@"
.endmacro # build_github
.
.macro build_travis(build)
.   define my.build = build_travis.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    build_from_travis $(my.build.github) $(my.build.repository) $(my.build.branch) $(my.parallel) $(my.options) "$@"
.endmacro # build_travis
.
.macro define_build_all(install)
.   define my.install = define_build_all.install
build_all()
{
.   for my.install.build as _build
.       # Unique by build.name
.       if !defined(my.build_$(_build.name:c))
.           define my.build_$(_build.name:c) = 0
.
.           if (is_icu_build(_build))
.               build_from_tarball_icu()
.           elsif (is_zlib_build(_build))
.               build_from_tarball_zlib()
.           elsif (is_png_build(_build))
.               build_from_tarball_png()
.           elsif (is_qrencode_build(_build))
.               build_from_tarball_qrencode()
.           elsif (is_boost_build(_build))
.               build_boost()
.           elsif (is_github_build(_build))
.               if (!last())
.                   build_github(_build)
.               else
.                   build_travis(_build)
.               endif
.           else
.               abort "Invalid build type: $(_build.name)."
.           endif
.
.       endif
.   endfor _build    
}

.endmacro # define_build_all
.
.macro define_invoke()
create_directory "$BUILD_DIR"
push_directory "$BUILD_DIR"
initialize_git
pop_directory
time build_all "${CONFIGURE_OPTIONS[@]}"
.endmacro # define_invoke
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_installer()
for generate.repository by name as _repository
    require(_repository, "repository", "name")
    create_directory(_repository.name)
    define my.out_file = "$(_repository.name)/install.sh"
    notify(my.out_file)
    output(my.out_file)
    
    shebang("bash")
    define my.install = _repository->install
    copyleft(_repository.name)
    install_documentation(_repository)
    
    heading1("Define constants.")
    define_build_directory(_repository)
    define_object_directory(_repository)
    define_icu(my.install)
    define_zlib(my.install)
    define_png(my.install)
    define_qrencode(my.install)
    define_boost(my.install)
    
    heading1("Initialize the build environment.")
    define_initialize()
    
    heading1("Define build options.")
    for my.install.build as _build where count(_build.option) > 0
         define_build_options(_build)
    endfor _build

    heading1("Define utility functions.")
    define_utility_functions()
    
    heading1("Define build functions.")
    define_build_functions()
        
    heading1("The master build function.")
    define_build_all(my.install)

    heading1("Build the primary library and all dependencies.")
    define_invoke()
    
    close
endfor _repository
endfunction # generate_installer
.endtemplate




