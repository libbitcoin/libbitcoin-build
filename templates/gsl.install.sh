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

function is_archive_match(build, name, compiler)
    define my.build = is_archive_match.build
    trace1("is_archive_match($(my.name), $(my.compiler ? 0)) : $(my.build.name)")
    return defined(my.build.version) & (my.build.name = my.name) & \
        (!defined(my.compiler) | !defined(my.build.compiler) | \
        (my.build.compiler = my.compiler))
endfunction

function get_archive_version(install, name, compiler)
    trace1("get_archive_version($(my.name), $(my.compiler ? 0))")
    define my.install = get_archive_version.install
    define my.build = my.install->build(is_archive_match(build, my.name, my.compiler))?
    return defined(my.build) ?? my.build.version
endfunction

# Functions with specific knowledge of Boost archive file name and URL structure.

function get_boost_file(install, compiler)
    define my.install = get_boost_file.install
    define my.version = get_archive_version(my.install, "boost", my.compiler)?
    if (!defined(my.version))
        trace1("get_boost_file:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "boost_$(my.underscore_version).tar.bz2"
endfunction

function get_boost_url(install, compiler)
    trace1("get_boost_url($(my.compiler ? 0))")
    define my.install = get_boost_url.install
    define my.version = get_archive_version(my.install, "boost", my.compiler)?
    if (!defined(my.version))
        trace1("get_boost_url:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.archive = get_boost_file(my.install, my.compiler)?
    if (!defined(my.archive))
        trace1("get_boost_url:get_boost_file($(my.compiler ? 0)) = []")
        return
    endif
    define my.base_url = "http\://github.com/libbitcoin/libbitcoin-build/blob/master/mirror"
    define my.url = "$(my.base_url)/$(my.archive)?raw=true"
    trace1("get_boost_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of ICU archive file name and URL structure.

function get_icu_file(install, compiler)
    define my.install = get_icu_file.install
    define my.version = get_archive_version(my.install, "icu", my.compiler)?
    if (!defined(my.version))
        trace1("get_icu_file:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "icu4c-$(my.underscore_version)-src.tgz"
endfunction

function get_icu_url(install, compiler)
    trace1("get_icu_url($(my.compiler ? 0))")
    define my.install = get_icu_url.install
    define my.version = get_archive_version(my.install, "icu", my.compiler)?
    if (!defined(my.version))
        trace1("get_icu_url:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.archive = get_icu_file(my.install, my.compiler)?
    if (!defined(my.archive))
        trace1("get_icu_url:get_icu_file($(my.compiler ? 0)) = []")
        return
    endif
    define my.base_url = "http\://download.icu-project.org/files/icu4c"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)"
    trace1("get_icu_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of PNG archive file name and URL structure.

function get_png_file(install, compiler)
    define my.install = get_png_file.install
    define my.version = get_archive_version(my.install, "png", my.compiler)?
    if (!defined(my.version))
        trace1("get_png_file:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    return "libpng-$(my.version).tar.xz"
endfunction

function get_png_url(install, compiler)
    trace1("get_png_url($(my.compiler ? 0))")
    define my.install = get_png_url.install
    define my.version = get_archive_version(my.install, "png", my.compiler)?
    if (!defined(my.version))
        trace1("get_png_url:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.archive = get_png_file(my.install, my.compiler)?
    if (!defined(my.archive))
        trace1("get_png_url:get_png_file($(my.compiler ? 0)) = []")
        return
    endif
    define my.base_url = "http://downloads.sourceforge.net/project/libpng/libpng16"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)"
    trace1("get_png_url = $(my.url)")
    return my.url
endfunction

# Functions with specific knowledge of QRENCODE archive file name and URL structure.

function get_qrencode_file(install, compiler)
    define my.install = get_qrencode_file.install
    define my.version = get_archive_version(my.install, "qrencode", my.compiler)?
    if (!defined(my.version))
        trace1("get_qrencode_file:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.underscore_version = string.convch(my.version, ".", "_")
    return "qrencode-$(my.version).tar.bz2"
endfunction

function get_qrencode_url(install, compiler)
    trace1("get_qrencode_url($(my.compiler ? 0))")
    define my.install = get_qrencode_url.install
    define my.version = get_archive_version(my.install, "qrencode", my.compiler)?
    if (!defined(my.version))
        trace1("get_qrencode_url:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    define my.archive = get_qrencode_file(my.install, my.compiler)?
    if (!defined(my.archive))
        trace1("get_qrencode_url:get_qrencode_file($(my.compiler ? 0)) = []")
        return
    endif
    define my.base_url = "http\://fukuchi.org/works/qrencode"
    define my.url = "$(my.base_url)/$(my.archive)"
    trace1("get_qrencode_url = $(my.url)")
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
.   if (have_build(my.repo->install, "qrencode"))
# --build-qrencode         Builds QREncode libraries.
.   endif
.   if (have_build(my.repo->install, "png"))
# --build-png              Builds LIBPNG libraries.
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
.macro define_icu(install, compiler)
.   trace1("define_icu($(my.compiler ? 0))")
.   define my.install = define_icu.install
.   define my.show_compiler = defined(my.compiler) ?? " for $(my.compiler)" ? ""
.   define my.upper_compiler = defined(my.compiler) ?? "_$(my.compiler:upper,c)" ? ""
.   define my.url = get_icu_url(my.install, my.compiler)?
.   if (!defined(my.url))
.       #abort "A version of icu$(my.show_compiler) is not defined."
.       return
.   endif
.   heading2("ICU archive$(my.show_compiler).")
ICU_URL$(my.upper_compiler)="$(my.url)"
ICU_ARCHIVE$(my.upper_compiler)="$(get_icu_file(my.install, my.compiler))"
ICU_STANDARD=\\
"CXXFLAGS=-std=c++0x"

.endmacro # define_icu
.
.macro define_png(install, compiler)
.   trace1("define_png($(my.compiler ? 0))")
.   define my.install = define_png.install
.   define my.url = get_png_url(my.install)?
.   if (!defined(my.url))
.       #abort "A version of png is not defined."
.       return
.   endif
.   heading2("PNG archive.")
PNG_URL="$(my.url)"
PNG_ARCHIVE="$(get_png_file(my.install))"
PNG_STANDARD=\\
""

.endmacro # define_png
.
.macro define_qrencode(install, compiler)
.   trace1("define_qrencode($(my.compiler ? 0))")
.   define my.install = define_qrencode.install
.   define my.show_compiler = defined(my.compiler) ?? " for $(my.compiler)" ? ""
.   define my.upper_compiler = defined(my.compiler) ?? "_$(my.compiler:upper,c)" ? ""
.   define my.url = get_qrencode_url(my.install, my.compiler)?
.   if (!defined(my.url))
.       #abort "A version of qrencode$(my.show_compiler) is not defined."
.       return
.   endif
.   heading2("QRENCODE archive$(my.show_compiler).")
QRENCODE_URL$(my.upper_compiler)="$(my.url)"
QRENCODE_ARCHIVE$(my.upper_compiler)="$(get_qrencode_file(my.install, my.compiler))"
QRENCODE_STANDARD=\\
""

.endmacro # define_qrencode
.
.macro define_boost(install, compiler)
.   trace1("define_boost($(my.compiler ? 0))")
.   define my.install = define_boost.install
.   define my.show_compiler = defined(my.compiler) ?? " for $(my.compiler)" ? ""
.   define my.upper_compiler = defined(my.compiler) ?? "_$(my.compiler:upper,c)" ? ""
.   define my.url = get_boost_url(my.install, my.compiler)?
.   if (!defined(my.url))
.       #abort "A version of boost$(my.show_compiler) is not defined."
.       return
.   endif
.   heading2("Boost archive$(my.show_compiler).")
BOOST_URL$(my.upper_compiler)="$(my.url)"
BOOST_ARCHIVE$(my.upper_compiler)="$(get_boost_file(my.install, my.compiler))"
BOOST_STANDARD$(my.upper_compiler)=\\
"threading=multi "\\
"variant=release "\\
"-d0 "\\
"-q"

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
echo "Make jobs: $PARALLEL"
echo "Make for system: $OS"

.   heading2("Define operating system specific settings.")
if [[ $OS == Darwin ]]; then
    # Always require clang, common lib linking will otherwise fail.
    export CC="clang"
    export CXX="clang++"
    LIBC="libc++"

    # Always initialize prefix on OSX so default is useful.
    PREFIX="/usr/local"
elif [[ $OS == OpenBSD ]]; then
    make() { gmake "$@"; }
    export CC="egcc"
    export CXX="eg++"
    LIBC="libestdc++"
else
    LIBC="libstdc++"
fi
echo "Make with cc: $CC"
echo "Make with cxx: $CXX"
echo "Make with stdlib: $LIBC"

.   heading2("Define compiler specific settings.")
COMPILER="GCC"
if [[ $CXX == "clang++" ]]; then
    BOOST_TOOLS="toolset=clang cxxflags=-stdlib=$LIBC linkflags=-stdlib=$LIBC"  
    COMPILER="CLANG"
fi

.   heading2("Parse command line options that are handled by this script.")
for OPTION in "$@"; do
    case $OPTION in
        # Custom build options (in the form of --build-<option>).
        (--build-icu)      BUILD_ICU="yes";;
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
echo "Build directory: $BUILD_DIR"
echo "Prefix directory: $PREFIX"

.   heading2("Warn on configurations that imply static/prefix isolation.")
if [[ $BUILD_ICU == yes ]]; then
    if [[ !($PREFIX)]]; then
        echo "Warning: --prefix recommended when building ICU."
    fi
    if [[ !($DISABLE_SHARED) ]]; then
        echo "Warning: --disable-shared recommended when building ICU."
    fi
fi
if [[ $BUILD_QRENCODE == yes ]]; then
    if [[ !($PREFIX)]]; then
        echo "Warning: --prefix recommended when building QRENCODE."
    fi
    if [[ !($DISABLE_SHARED) ]]; then
        echo "Warning: --disable-shared recommended when building QRENCODE."
    fi
fi
if [[ $BUILD_PNG == yes ]]; then
    if [[ !($PREFIX)]]; then
        echo "Warning: --prefix recommended when building PNG."
    fi
    if [[ !($DISABLE_SHARED) ]]; then
        echo "Warning: --disable-shared recommended when building PNG."
    fi
fi
if [[ $BUILD_BOOST == yes ]]; then
    if [[ !($PREFIX)]]; then    
        echo "Warning: --prefix recommended when building boost."
    fi
    if [[ !($DISABLE_SHARED) ]]; then
        echo "Warning: --disable-shared recommended when building boost."
    fi
fi

.   heading2("Purge custom options so they don't go to configure.")
CONFIGURE_OPTIONS=( "$@" )
CUSTOM_OPTIONS=( "--build-icu" "--build-boost" "--build-png" "--build-qrencode" "--build-dir=$BUILD_DIR")
for CUSTOM_OPTION in "${CUSTOM_OPTIONS[@]}"; do
    CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/$CUSTOM_OPTION}" )
done

.   heading2("Set link variables.")
if [[ $DISABLE_STATIC == yes ]]; then
    BOOST_LINK="link=shared"
    ICU_LINK="--enable-shared --disable-static"
    PNG_LINK="--enable-shared --disable-static"
    QRENCODE_LINK="--enable-shared --disable-static"
elif [[ $DISABLE_SHARED == yes ]]; then
    BOOST_LINK="link=static"
    ICU_LINK="--disable-shared --enable-static"
    PNG_LINK="--disable-shared --enable-static"
    QRENCODE_LINK="--disable-shared --enable-static"
else
    BOOST_LINK="link=static,shared"
    ICU_LINK="--enable-shared --enable-static"
    PNG_LINK="--enable-shared --enable-static"
    QRENCODE_LINK="--enable-shared --enable-static"
fi

.   heading2("Incorporate the prefix.")
if [[ $PREFIX ]]; then
    # Set the prefix-based package config directory.
    PREFIX_PKG_CONFIG_DIR="$PREFIX/lib/pkgconfig"

    # Augment PKG_CONFIG_PATH search path with our prefix.
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$PREFIX_PKG_CONFIG_DIR"
    
    # Set public prefix variable.
    prefix="--prefix=$PREFIX"
    
    # Set a package config save path that can be passed via our builds.
    with_pkgconfigdir="--with-pkgconfigdir=$PREFIX_PKG_CONFIG_DIR"
    
    if [[ $BUILD_BOOST ]]; then
        # Boost has no pkg-config, m4 searches in the following order:
        # --with-boost=<path>, /usr, /usr/local, /opt, /opt/local, $BOOST_ROOT.
        # We use --with-boost to prioritize the --prefix path when we build it.
        # Otherwise standard paths suffice for Linux, Homebrew and MacPorts.
        with_boost="--with-boost=$PREFIX" 
    fi
fi

.   heading2("Echo published dynamic build options.")
echo "  prefix: ${prefix}"
echo "  with_boost: ${with_boost}"
echo "  with_pkgconfigdir: ${with_pkgconfigdir}"

.endmacro # define_initialize
.
.macro define_build_options(build)
.   define my.build = define_build_options.build
.   define my.show_compiler = defined(my.build.compiler) ?? " for $(my.build.compiler)" ? ""
.   define my.compiler_name = defined(my.build.compiler) ?? "_$(my.build.compiler:upper,c)" ? ""
.   heading2("Define $(my.build.name) options$(my.show_compiler).")
$(my.build.name:upper,c)_OPTIONS$(my.compiler_name)=\\
.   for my.build.option as _option
"$(_option.value) "$(!last() ?? "\\")
.   endfor _option

.endmacro # define_build_options
.
.macro define_utility_functions()
.
circumvent_boost_icu_detection()
{
    # Boost expects a directory structure for ICU which is incorrect.
    # Boost ICU discovery fails when using prefix, can't fix with -sICU_LINK,
    # so we rewrite the two 'has_icu_test.cpp' files to always return success.
    
    if [[ $WITH_ICU ]]; then
        local SUCCESS="int main() { return 0; }"
        local REGEX_TEST="libs/regex/build/has_icu_test.cpp"
        local LOCALE_TEST="libs/locale/build/has_icu_test.cpp"
        
        echo $SUCCESS > $REGEX_TEST
        echo $SUCCESS > $LOCALE_TEST

        echo "hack: ICU detection modified, will always indicate found."
    fi
}

configure_options()
{
    echo "configure: $@"
    ./configure "$@"
}

configure_links()
{
    # Configure dynamic linker run-time bindings.
    if [[ ($OS == Linux) && !($PREFIX) ]]; then
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
    MESSAGE="$1"
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

initialize_boost_icu()
{
    if [[ $WITH_ICU ]]; then
        # Restrict other local options when compiling boost with icu.
        BOOST_ICU_ONLY="boost.locale.iconv=off boost.locale.posix=off"
        
        # Extract ICU prefix directory from package config variable.
        local ICU_PREFIX=`pkg-config icu-i18n --variable=prefix`
        BOOST_ICU_PATH="-sICU_PATH=$ICU_PREFIX"
        BOOTSTRAP_WITH_ICU="--with-icu=$ICU_PREFIX"

        # Extract ICU libs from package config variables and augment with -ldl.
        local ICU_LIBS="`pkg-config icu-i18n --libs` -ldl"
        BOOST_ICU_LINK="-sICU_LINK=$ICU_LIBS"
    fi
}

initialize_icu_packages()
{
    if [[ ($OS == Darwin) && !($BUILD_ICU) ]]; then
        # Update PKG_CONFIG_PATH for ICU package installations on OSX.
        # OSX provides libicucore.dylib with no pkgconfig and doesn't support
        # renaming or important features, so we can't use that.
        HOMEBREW_ICU_PKG_CONFIG="/usr/local/opt/icu4c/lib/pkgconfig"
        MACPORTS_ICU_PKG_CONFIG="/opt/local/lib/pkgconfig"
        
        if [[ -d "$HOMEBREW_ICU_PKG_CONFIG" ]]; then
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$HOMEBREW_ICU_PKG_CONFIG"
        elif [[ -d "$MACPORTS_ICU_PKG_CONFIG" ]]; then
            export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$MACPORTS_ICU_PKG_CONFIG"
        fi
    fi
}

initialize_options()
{
    if [[ !($BOOST_OPTIONS) ]]; then
        # Select compiler-conditional generated configuration parameters.
        if [[ $COMPILER == CLANG ]]; then
            BOOST_URL=$BOOST_URL_CLANG
            BOOST_ARCHIVE=$BOOST_ARCHIVE_CLANG
            BOOST_STANDARD=$BOOST_STANDARD_CLANG
            BOOST_OPTIONS=$BOOST_OPTIONS_CLANG
        else
            BOOST_URL=$BOOST_URL_GCC
            BOOST_ARCHIVE=$BOOST_ARCHIVE_GCC
            BOOST_STANDARD=$BOOST_STANDARD_GCC
            BOOST_OPTIONS=$BOOST_OPTIONS_GCC
        fi
    fi
}

make_current_directory()
{
    local JOBS=$1
    shift 1

    ./autogen.sh
    configure_options "$@"
    make_jobs $JOBS
    make install
    configure_links
}

make_jobs()
{
    local JOBS=$1
    local TARGET=$2

    # Avoid setting -j1 (causes problems on Travis).
    if [[ $JOBS > $SEQUENTIAL ]]; then
        make -j$JOBS $TARGET
    else
        make $TARGET
    fi
}

make_tests()
{
    local JOBS=$1

    # Build and run unit tests relative to the primary directory.
    # VERBOSE=1 ensures test-suite.log output sent to console (gcc).
    if ! make_jobs $JOBS check VERBOSE=1; then
        if [ -e "test-suite.log" ]; then
            echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo "cat test-suite.log"
            echo "------------------------------"
            cat "test-suite.log"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        fi
        exit 1
    fi
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

.   heading1("Build functions.")
.
build_from_tarball()
{
    local URL=$1
    local ARCHIVE=$2
    local ARCHIVE_TYPE=$3
    local JOBS=$4
    local PUSH_DIR=$5
    local LINK=$6
    local STANDARD=$7
    shift 7

    display_message "Download $ARCHIVE"

    local EXTRACTED_DIR=`echo $ARCHIVE | sed "s/.tar.$ARCHIVE_TYPE//g"`

    create_directory $EXTRACTED_DIR
    push_directory $EXTRACTED_DIR

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --$ARCHIVE_TYPE --strip-components=1
    push_directory $PUSH_DIR

    configure_options $LINK $STANDARD ${prefix} "$@"
    make_jobs $JOBS --silent
    make install
    configure_links

    pop_directory
    pop_directory
}

build_from_tarball_boost()
{
    local URL=$1
    local ARCHIVE=$2
    local REPO=$3
    local JOBS=$4
    shift 4

    if [[ !($BUILD_BOOST) ]]; then
        display_message "Boost build not enabled"
        return
    fi
    
    display_message "Download $ARCHIVE"

    create_directory $REPO
    push_directory $REPO

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --bzip2 --strip-components=1
    
    # Circumvent Boost ICU detection bug.
    circumvent_boost_icu_detection

    initialize_boost_icu
    
    # Build and install.
    BOOSTSTRAP_OPTIONS="${prefix} $BOOTSTRAP_WITH_ICU"
    B2_OPTIONS="install --reconfigure -j $JOBS ${prefix} $BOOST_LINK $BOOST_TOOLS $BOOST_STANDARD $BOOST_ICU_PATH $BOOST_ICU_LINK $BOOST_ICU_ONLY $@"
    
    echo "bootstrap: $BOOSTSTRAP_OPTIONS"
    echo "b2: $B2_OPTIONS"
    echo
    
    ./bootstrap.sh $BOOSTSTRAP_OPTIONS
    ./b2 $B2_OPTIONS
    
    # Boost has no pkg-config, m4 searches in the following order:
    # --with-boost=<path>, /usr, /usr/local, /opt, /opt/local, $BOOST_ROOT.
    # We use --with-boost to prioritize the --prefix path when we build it.
    # Otherwise standard paths suffice for Linux, Homebrew and MacPorts.
    with_boost="--with-boost=$PREFIX"

    pop_directory
}

build_from_github()
{
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    local JOBS=$4
    shift 4

    FORK="$ACCOUNT/$REPO"
    display_message "Download $FORK/$BRANCH"
    
    # Clone the repository locally.
    git clone --branch $BRANCH --single-branch "https://github.com/$FORK"

    # Build the local repository clone.
    push_directory $REPO
    make_current_directory $JOBS "$@"
    pop_directory
}

build_from_local()
{
    local MESSAGE="$1"
    local JOBS=$2
    shift 2

    display_message "$MESSAGE"

    # Build the current directory.
    make_current_directory $JOBS "$@"
}

build_from_travis()
{
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    local JOBS=$4
    shift 4

    # The primary build is not downloaded if we are running in Travis.
    if [[ $TRAVIS == true ]]; then
        push_directory ".."
        build_from_local "Local $TRAVIS_REPO_SLUG" $JOBS "$@"
        make_tests $JOBS
        pop_directory
    else
        build_from_github $ACCOUNT $REPO $BRANCH $JOBS "$@"
        push_directory $REPO
        make_tests $JOBS
        pop_directory
    fi
}

.endmacro # define_utility_functions
.
.macro build_from_tarball_icu()
    build_from_tarball $ICU_URL $ICU_ARCHIVE gzip $PARALLEL source $ICU_LINK $ICU_STANDARD $ICU_OPTIONS
.endmacro # build_icu
.
.macro build_from_tarball_png()
    build_from_tarball $PNG_URL $PNG_ARCHIVE xz $PARALLEL . $PNG_LINK $PNG_STANDARD $PNG_OPTIONS
.endmacro # build_png
.
.macro build_from_tarball_qrencode()
    build_from_tarball $QRENCODE_URL $QRENCODE_ARCHIVE bzip2 $PARALLEL . $QRENCODE_LINK $QRENCODE_STANDARD $QRENCODE_OPTIONS
.endmacro # build_qrencode
.
.macro build_boost()
    build_from_tarball_boost $BOOST_URL $BOOST_ARCHIVE boost $PARALLEL $BOOST_OPTIONS
.endmacro # build_boost
.
.macro build_github(build)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "$$(my.build.name:upper,c)_OPTIONS"
    build_from_github $(my.build.github) $(my.build.repository) $(my.build.branch) $(my.parallel) "$@" $(my.options)
.endmacro # build_github
.
.macro build_travis(build)
.   define my.build = build_travis.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "$$(my.build.name:upper,c)_OPTIONS"
    build_from_travis $(my.build.github) $(my.build.repository) $(my.build.branch) $(my.parallel) "$@" $(my.options)
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
.           if (is_boost_build(_build))
.               build_boost()
.           elsif (is_icu_build(_build))
.               build_from_tarball_icu()
.           elsif (is_png_build(_build))
.               build_from_tarball_png()
.           elsif (is_qrencode_build(_build))
.               build_from_tarball_qrencode()
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
initialize_options
time build_all "${CONFIGURE_OPTIONS[@]}"
pop_directory
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
    
    heading1("Define common constants.")
    define_build_directory(_repository)
    define_icu(my.install)
    define_png(my.install)
    define_qrencode(my.install)
    define_boost(my.install, "gcc")
    define_boost(my.install, "clang")
    
    heading1("Initialize the build environment.")
    define_initialize()
    
    heading1("Define build options.")
    for my.install.build as _build where count(_build.option) > 0
         define_build_options(_build)
    endfor _build

    heading1("Define utility functions.")
    define_utility_functions()
        
    heading1("The master build function.")
    define_build_all(my.install)

    heading1("Build the primary library and all dependencies.")
    define_invoke()
    
    close
endfor _repository
endfunction # generate_installer
.endtemplate




