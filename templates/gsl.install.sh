.template 0
###############################################################################
# Copyright (c) 2011-2014 libbitcoin developers (see COPYING).
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
    return defined(my.install->build(build.name = my.name))
endfunction

function is_archive_match(build, name, compiler)
    define my.build = is_archive_match.build
    trace1("is_archive_match($(my.name), $(my.compiler ? 0)) : $(my.build.name)")
    return defined(my.build.version) & (my.build.name = my.name) & \
        (!defined(my.compiler) | (my.build.compiler = my.compiler))
endfunction

function get_archive_version(install, name, compiler)
    trace1("get_archive_version($(my.name), $(my.compiler ? 0))")
    define my.install = get_archive_version.install
    define my.build = my.install->build(is_archive_match(build, my.name, my.compiler))?
    return defined(my.build) ?? my.build.version
endfunction

# Functions with specific knowledge of archive file name and URL structure.

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

function get_gmp_file(install, compiler)
    define my.install = get_gmp_file.install
    define my.version = get_archive_version(my.install, "gmp", my.compiler)?
    if (!defined(my.version))    
        trace1("get_gmp_file:get_archive_version($(my.compiler ? 0)) = []")
        return
    endif
    return "gmp-$(my.version).tar.bz2"
endfunction

function get_boost_url(install, compiler)
    trace1("get_boost_url($(my.compiler) ? 0)")
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
    define my.base_url = "http\://sourceforge.net/projects/boost/files/boost"
    define my.url = "$(my.base_url)/$(my.version)/$(my.archive)/download"
    trace1("get_boost_url = $(my.url)")
    return my.url
endfunction

function get_gmp_url(install, compiler)
    define my.install = get_gmp_url.install
    define my.base_url = "https\://ftp.gnu.org/gnu/gmp"
    define my.archive = get_gmp_file(my.install, my.compiler)?
    if (!defined(my.archive))
        trace1("get_gmp_url:get_gmp_file($(my.compiler ? 0)) = []")
        return
    endif
    define my.url = "$(my.base_url)/$(my.archive)"
    trace1("get_gmp_url = $(my.url)")
    return my.url
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro language(interpreter)
#!/bin/$(my.interpreter)
.endmacro # language
.
.macro documentation(repository)
.   define my.repo = documentation.repository
# Script to build and install $(my.repo.name).
#
# Script options:
.   if (have_build(my.repo->install, "gmp"))
# --build-gmp              Builds GMP library.
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
# Values (e.g. yes|no) in the boolean options are not supported by the script.
# All command line options are passed to 'configure' of each repo, with
# the exception of the --build-<item> options, which are for the script only.
# Depending on the caller's permission to the --prefix or --build-dir
# directory, the script may need to be sudo'd.
.endmacro documentation
.
.macro define_build_directory(repository)
.   define my.repo = define_build_directory.repository
.   heading2("The default build directory.")
BUILD_DIR="build-$(my.repo.name)"

.endmacro # define_build_directory
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
.   heading2("Boost archives$(my.show_compiler).")
BOOST_URL$(my.upper_compiler)="$(my.url)"
BOOST_ARCHIVE$(my.upper_compiler)="$(get_boost_file(my.install, my.compiler))"

.endmacro # define_boost
.
.macro define_gmp(install, compiler)
.   trace1("define_gmp($(my.compiler ? 0))")
.   define my.install = define_gmp.install
.   define my.show_compiler = defined(my.compiler) ?? " for $(my.compiler)" ? ""
.   define my.upper_compiler = defined(my.compiler) ?? "_$(my.compiler:upper,c)" ? ""
.   heading2("GMP archives$(my.show_compiler).")
.   define my.url = get_gmp_url(my.install, my.compiler)?
.   if (!defined(my.url))
.       #abort "A version of gmp$(my.show_compiler) is not defined."
.       return
.   endif
GMP_URL$(my.upper_compiler)="$(my.url)"
GMP_ARCHIVE$(my.upper_compiler)="$(get_gmp_file(my.install, my.compiler))"

.endmacro # define_gmp
.
.macro define_initialize()
.   heading2("Exit this script on the first build error.")
set -e

.   heading2("Configure build parallelism.")
SEQUENTIAL=1
OS=`uname -s`
if [[ $TRAVIS == true ]]; then
    PARALLEL=$SEQUENTIAL
elif [[ $OS == Linux ]]; then
    PARALLEL=`nproc`
elif [[ $OS == Darwin ]]; then
    PARALLEL=2 #TODO
else
    echo "Unsupported system: $OS"
    exit 1
fi
echo "Make jobs: $PARALLEL"
echo "Make for system: $OS"

.   heading2("Define operating system settings.")
if [[ $OS == Darwin ]]; then

    # Always require CLang, common lib linking will otherwise fail.
    export CC="clang"
    export CXX="clang++"
    
    # Always initialize prefix on OSX so default is consistent.
    PREFIX="/usr/local"
fi
echo "Make with cc: $CC"
echo "Make with cxx: $CXX"

.   heading2("Parse command line options that are handled by this script.")
for OPTION in "$@"; do
    case $OPTION in
        (--prefix=*) PREFIX="${OPTION#*=}";;
        (--build-dir=*) BUILD_DIR="${OPTION#*=}";;

        (--build-gmp) BUILD_GMP="yes";;
        (--build-boost) BUILD_BOOST="yes";;
        
        (--disable-shared) DISABLE_SHARED="yes";;
        (--disable-static) DISABLE_STATIC="yes";;
    esac
done
echo "Build directory: $BUILD_DIR"
echo "Prefix directory: $PREFIX"

.   heading2("Purge our custom options so they don't go to configure.")
CONFIGURE_OPTIONS=( "$@" )
CUSTOM_OPTIONS=( "--build-dir=$BUILD_DIR" "--build-boost" "--build-gmp" )
for CUSTOM_OPTION in "${CUSTOM_OPTIONS[@]}"; do
    CONFIGURE_OPTIONS=( "${CONFIGURE_OPTIONS[@]/$CUSTOM_OPTION}" )
done

.   heading2("Set public boost_link variable (to translate libtool link to Boost build).")
if [[ $DISABLE_STATIC == yes ]]; then
    boost_link="link=shared"
elif [[ $DISABLE_SHARED == yes ]]; then
    boost_link="link=static"
else
    boost_link="link=static,shared"
fi

.   heading2("Incorporate the prefix.")
if [[ $PREFIX ]]; then

    # Set public with_pkgconfigdir variable (for packages that handle it).
    PKG_CONFIG_DIR="$PREFIX/lib/pkgconfig"
    with_pkgconfigdir="--with-pkgconfigdir=$PKG_CONFIG_DIR"
    
    # Augment PKG_CONFIG_PATH with prefix path. 
    # If all libs support --with-pkgconfigdir we could avoid this variable.
    # Currently all relevant dependencies support it except secp256k1.
    # TODO: patch secp256k1 and disable this.
    export PKG_CONFIG_PATH="$PKG_CONFIG_DIR:$PKG_CONFIG_PATH"

    # Boost m4 discovery searches in the following order:
    # --with-boost=<path>, /usr, /usr/local, /opt, /opt/local, BOOST_ROOT.
    # We use --with-boost to prioritize the --prefix path when we build it.
    # Otherwise the standard paths suffice for Linux, Homebrew and MacPorts.

    # Set public with_boost variable (because Boost has no pkg-config).
    if [[ $BUILD_BOOST == yes ]]; then
        with_boost="--with-boost=$PREFIX"
    fi
    
    # Set public gmp_flags variable (because GMP has no pkg-config).
    if [[ $BUILD_GMP == yes ]]; then
        gmp_flags="CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib"
    fi
    
    # Set public prefix variable (to tell Boost where to build).
    prefix="--prefix=$PREFIX"
fi

.   heading2("Echo published dynamic build options.")
echo "Published dynamic options:"
echo "  boost_link: $boost_link"
echo "  prefix: $prefix"
echo "  gmp_flags: $gmp_flags"
echo "  with_boost: $with_boost"
echo "  with_pkgconfigdir: $with_pkgconfigdir"

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
.macro define_compiler_settings()
if [[ $CXX == "clang++" ]]; then
    BOOST_URL="$BOOST_URL_CLANG"
    BOOST_ARCHIVE="$BOOST_ARCHIVE_CLANG"
    BOOST_OPTIONS="$BOOST_OPTIONS_CLANG"
else # g++
    BOOST_URL="$BOOST_URL_GCC"
    BOOST_ARCHIVE="$BOOST_ARCHIVE_GCC"
    BOOST_OPTIONS="$BOOST_OPTIONS_GCC"
fi

.endmacro # define_compiler_settings
.
.macro define_utility_functions()
.
configure_options()
{
    echo "configure: $@"
    ./configure "$@"
}

create_directory()
{
    local DIRECTORY="$1"

    rm -rf "$DIRECTORY"
    mkdir "$DIRECTORY"
}

display_linkage()
{
    local LIBRARY="$1"
    
    # Display shared library links.
    if [[ $OS == Darwin ]]; then
        otool -L "$LIBRARY"
    else
        ldd --verbose "$LIBRARY"
    fi
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

make_current_directory()
{
    local JOBS=$1
    shift 1

    ./autogen.sh
    configure_options "$@"
    make_jobs $JOBS
    make install

    # Use ldconfig only in case of non --prefix installation on Linux.    
    if [[ ($OS == Linux) && !($PREFIX)]]; then
        ldconfig
    fi
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
    make_jobs $JOBS check
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
build_from_tarball_boost()
{
    local URL=$1
    local ARCHIVE=$2
    local REPO=$3
    local JOBS=$4
    shift 4

    if [[ $BUILD_BOOST != yes ]]; then
        display_message "Boost build not enabled"
        return
    fi
    
    display_message "Download $ARCHIVE"

    create_directory $REPO
    push_directory $REPO

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --bzip2 --strip-components=1

    echo "configure: $@"
    echo

    # Build and install (note that "$@" is not from script args).
    ./bootstrap.sh
    ./b2 install -j $JOBS "$@"

    pop_directory
}

build_from_tarball_gmp()
{
    local URL=$1
    local ARCHIVE=$2
    local REPO=$3
    local JOBS=$4
    shift 4

    if [[ $BUILD_GMP != yes ]]; then
        display_message "GMP build not enabled"
        return
    fi

    display_message "Download $ARCHIVE"
    
    create_directory $REPO
    push_directory $REPO
    
    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --bzip2 --strip-components=1

    # Build the local sources.
    # GMP does not provide autogen.sh or package config.
    configure_options "$@"

    # GMP does not honor noise reduction.
    echo "Making all..."
    make_jobs $JOBS >/dev/null
    echo "Installing all..."
    make install >/dev/null

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
        # TODO: enable so build-dir in travis can be absolute or multi-segment.
        # push_directory "$TRAVIS_BUILD_DIR"
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
.macro build_gmp()
    build_from_tarball_gmp $GMP_URL $GMP_ARCHIVE gmp $PARALLEL "$@" $GMP_OPTIONS
.endmacro # build_gmp
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
.           if (is_gmp_build(_build))
.               build_gmp()
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
    define my.out_file = "$(_repository.name)/install.sh"
    notify(my.out_file)
    output(my.out_file)
    
    language("bash")
    define my.install = _repository->install
    copyleft(_repository.name)
    documentation(_repository)
    
    heading1("Define common constants.")
    define_build_directory(_repository)
    define_boost(my.install, "gcc")
    define_boost(my.install, "clang")
    define_gmp(my.install)
    
    heading1("Initialize the build environment.")
    define_initialize()
    
    heading1("Define build options.")
    for my.install.build as _build where count(_build.option) > 0
         define_build_options(_build)
    endfor _build

    heading1("Define compiler settings.")
    define_compiler_settings()

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




