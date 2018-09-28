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

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro custom_help(repository, install, script_name)
    display_message "  --build-dir=<path>       Location of downloaded and intermediate files."
.endmacro # custom_help
.
.macro custom_documentation(repository, install)
# --build-dir=<path>       Location of downloaded and intermediate files.
.endmacro # custom_documentation
.
.macro custom_configuration(repository, install)
    display_message "BUILD_DIR             : $BUILD_DIR"
.endmacro # custom_configuration
.
.macro custom_script_options()
        # Unique script options.
        (--build-dir=*)    BUILD_DIR="${OPTION#*=}";;
.endmacro # custom_script_options
.
.macro define_build_directory(repository)
.   define my.repo = define_build_directory.repository
.   heading2("The default build directory.")
BUILD_DIR="build-$(my.repo.name)"

.endmacro # define_build_directory
.
.macro define_configure_options()
configure_options()
{
    display_message "configure options:"
    for OPTION in "$@"; do
        if [[ $OPTION ]]; then
            display_message $OPTION
        fi
    done

    ./configure "$@"
}

.endmacro # define_configure_options
.
.macro define_create_directory()
create_directory()
{
    local DIRECTORY="$1"

    rm -rf "$DIRECTORY"
    mkdir "$DIRECTORY"
}

.endmacro # define_create_directory
.
.macro define_make_current_directory()
# make_current_directory jobs [configure_options]
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

.endmacro # define_make_current_directory
.
.macro define_make_jobs()
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

.endmacro # define_make_jobs
.
.macro define_utility_functions()
.   define_configure_links()
.   define_configure_options()
.   define_create_directory()
.   define_display_functions()
.   define_initialize_git()
.   define_make_current_directory()
.   define_make_jobs()
.   define_make_tests("false")
.   define_push_pop_directory()
.endmacro # define_utility_functions
.
.macro define_build_from_tarball()
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

    display_heading_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory "$EXTRACT"
    push_directory "$EXTRACT"

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --$COMPRESSION --strip-components=1
    push_directory "$PUSH_DIR"

    # Enable static only zlib build.
    if [[ $ARCHIVE == $ZLIB_ARCHIVE ]]; then
        patch_zlib_configuration
    fi

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    if [[ $ARCHIVE == $MBEDTLS_ARCHIVE ]]; then
        make -j $JOBS lib
        make DESTDIR=$PREFIX install
    else
        configure_options "${CONFIGURATION[@]}"
        make_jobs $JOBS --silent
        make install
    fi

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

.endmacro # define_build_from_tarball
.
.macro define_build_from_tarball_boost()
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

    display_heading_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory "$EXTRACT"
    push_directory "$EXTRACT"

    # Extract the source locally.
    wget --output-document $ARCHIVE $URL
    tar --extract --file $ARCHIVE --$COMPRESSION --strip-components=1

    initialize_boost_configuration
    initialize_boost_icu_configuration

    display_message "Libbitcoin boost configuration."
    display_message "--------------------------------------------------------------------"
    display_message "variant               : release"
    display_message "threading             : multi"
    display_message "toolset               : $CC"
    display_message "cxxflags              : $STDLIB_FLAG"
    display_message "linkflags             : $STDLIB_FLAG"
    display_message "link                  : $BOOST_LINK"
    display_message "boost.locale.iconv    : $BOOST_ICU_ICONV"
    display_message "boost.locale.posix    : $BOOST_ICU_POSIX"
    display_message "-sNO_BZIP2            : 1"
    display_message "-sICU_PATH            : $ICU_PREFIX"
    display_message "-sICU_LINK            : ${ICU_LIBS[@]}"
    display_message "-sZLIB_LIBPATH        : $PREFIX/lib"
    display_message "-sZLIB_INCLUDE        : $PREFIX/include"
    display_message "-j                    : $JOBS"
    display_message "-d0                   : [supress informational messages]"
    display_message "-q                    : [stop at the first error]"
    display_message "--reconfigure         : [ignore cached configuration]"
    display_message "--prefix              : $PREFIX"
    display_message "BOOST_OPTIONS         : $@"
    display_message "--------------------------------------------------------------------"

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

.endmacro # define_build_from_tarball_boost
.
.macro define_build_from_github()
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
    display_heading_message "Download $FORK/$BRANCH"

    # Clone the repository locally.
    git clone --depth 1 --branch $BRANCH --single-branch "https://github.com/$FORK"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    # Build the local repository clone.
    push_directory "$REPO"
    make_current_directory $JOBS "${CONFIGURATION[@]}"
    pop_directory
    pop_directory
}

.endmacro # define_build_from_github
.
.macro define_build_from_local()
# Standard build of current directory.
build_from_local()
{
    local MESSAGE="$1"
    local JOBS=$2
    local OPTIONS=$3
    shift 3

    display_heading_message "$MESSAGE"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    # Build the current directory.
    make_current_directory $JOBS "${CONFIGURATION[@]}"
}

.endmacro # define_build_from_local
.
.macro define_build_from_travis()
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
        make_tests $JOBS
    else
        build_from_github $ACCOUNT $REPO $BRANCH $JOBS "${OPTIONS[@]}" "$@"
        push_directory "$BUILD_DIR"
        push_directory "$REPO"
        make_tests $JOBS
        pop_directory
        pop_directory
    fi
}

.endmacro # define_build_from_travis
.
.macro define_build_functions()
.   define_initialize_icu_packages()
.   define_patch_zlib_configuration()
.   define_clean_zlib_build()
.   define_build_from_tarball()
.   define_boost_build_configuration_helpers()
.   define_build_from_tarball_boost()
.   define_build_from_github()
.   define_build_from_local()
.   define_build_from_travis()
.endmacro # define_build_functions
.
.macro build_from_tarball_icu()
    build_from_tarball $ICU_URL $ICU_ARCHIVE gzip source $PARALLEL "$BUILD_ICU" "${ICU_OPTIONS[@]}" "$@"
.endmacro # build_icu
.
.macro build_from_tarball_zlib()
    build_from_tarball $ZLIB_URL $ZLIB_ARCHIVE gzip . $PARALLEL "$BUILD_ZLIB" "${ZLIB_OPTIONS[@]}" "$@"
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
.macro build_from_tarball_zmq()
    build_from_tarball $ZMQ_URL $ZMQ_ARCHIVE gzip . $PARALLEL "$BUILD_ZMQ" "${ZMQ_OPTIONS[@]}" "$@"
.endmacro # build_zmq
.
.macro build_from_tarball_mbedtls()
    build_from_tarball $MBEDTLS_URL $MBEDTLS_ARCHIVE gzip . $PARALLEL "$BUILD_MBEDTLS" "${MBEDTLS_OPTIONS[@]}" "$@"
.endmacro # build_mbedtls
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
.           elsif (is_zmq_build(_build))
.               build_from_tarball_zmq()
.           elsif (is_mbedtls_build(_build))
.               build_from_tarball_mbedtls()
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
if [[ $DISPLAY_HELP ]]; then
    display_help
else
    display_configuration
    create_directory "$BUILD_DIR"
    push_directory "$BUILD_DIR"
    initialize_git
    pop_directory
    time build_all "${CONFIGURE_OPTIONS[@]}"
fi
.endmacro # define_invoke
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_installer(path_prefix)
for generate.repository by name as _repository
    require(_repository, "repository", "name")
    my.output_path = join(my.path_prefix, _repository.name)
    define my.out_file = "$(my.output_path)/install.sh"
    define my.install = _repository->install
    create_directory(my.output_path)
    notify(my.out_file)
    output(my.out_file)

    shebang("bash")

    copyleft(_repository.name)
    documentation(_repository, my.install)

    heading1("Define constants.")
    define_build_directory(_repository)
    define_icu(my.install)
    define_zlib(my.install)
    define_png(my.install)
    define_qrencode(my.install)
    define_zmq(my.install)
    define_mbedtls(my.install)
    define_boost(my.install)

    heading1("Define utility functions.")
    define_utility_functions()
    define_help(_repository, my.install, "install")

    heading1("Initialize the build environment.")
    define_set_exit_on_error()
    define_read_parameters(_repository, my.install)
    define_parallelism()
    define_os_specific_settings()
    define_normalized_configure_options()
    # define_normalize_build_variables()
    define_prefix()
    define_pkgconfigdir()
    define_with_boost_prefix()
    define_display_configuration(_repository, my.install)

    heading1("Define build options.")
    for my.install.build as _build where count(_build.option) > 0
        define_build_options(_build)
    endfor _build

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
.template 0
###############################################################################
# Execution
###############################################################################
[global].root = ".."
[global].trace = 0
[gsl].ignorecase = 0

# Note: expected context root libbitcoin-build directory
gsl from "library/math.gsl"
gsl from "library/string.gsl"
gsl from "library/collections.gsl"
gsl from "utilities.gsl"
gsl from "templates/shared/common_install_shell_artifacts.gsl"

generate_installer("output")

.endtemplate
