.template 0
###############################################################################
# Copyright (c) 2014-2020 libbitcoin developers (see COPYING).
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
.macro define_handle_custom_options()
handle_custom_options()
{
    # bash doesn't like empty functions.
    FOO="bar"
}

.endmacro # define_handle_custom_options()
.
.macro define_configure_options()
configure_options()
{
    display_message "configure options:"
    for OPTION in "$@"; do
        if [[ $OPTION ]]; then
            display_message "$OPTION"
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
    make_jobs "$JOBS"
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

    SEQUENTIAL=1
    # Avoid setting -j1 (causes problems on single threaded systems [TRAVIS]).
    if [[ $JOBS > $SEQUENTIAL ]]; then
        make -j"$JOBS" "$@"
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
.   define_enable_exit_on_error()
.   define_disable_exit_on_error()
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
    if [[ ! ($BUILD) ]]; then
        if [[ $ARCHIVE == "$ICU_ARCHIVE" ]]; then
            initialize_icu_packages
        fi
        return
    fi

    # Because ICU tools don't know how to locate internal dependencies.
    if [[ ($ARCHIVE == "$ICU_ARCHIVE") ]]; then
        local SAVE_LDFLAGS="$LDFLAGS"
        export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
    fi

    display_heading_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory "$EXTRACT"
    push_directory "$EXTRACT"

    # Extract the source locally.
    wget --output-document "$ARCHIVE" "$URL"
    tar --extract --file "$ARCHIVE" "--$COMPRESSION" --strip-components=1
    push_directory "$PUSH_DIR"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    if [[ $ARCHIVE == "$MBEDTLS_ARCHIVE" ]]; then
        make -j "$JOBS" lib
        make DESTDIR=$PREFIX install
    else
        configure_options "${CONFIGURATION[@]}"
        make_jobs "$JOBS" --silent
        make install
    fi

    configure_links

    pop_directory
    pop_directory

    # Restore flags to prevent side effects.
    export LDFLAGS=$SAVE_LDFLAGS
    export CPPFLAGS=$SAVE_CPPFLAGS

    pop_directory
}

.endmacro # define_build_from_tarball
.
.macro define_build_from_tarball_boost()
# Because boost doesn't use autoconfig.
build_from_tarball_boost()
{
    local SAVE_IFS="$IFS"
    IFS=' '

    local URL=$1
    local ARCHIVE=$2
    local COMPRESSION=$3
    local PUSH_DIR=$4
    local JOBS=$5
    local BUILD=$6
    shift 6

    if [[ ! ($BUILD) ]]; then
        return
    fi

    display_heading_message "Download $ARCHIVE"

    # Use the suffixed archive name as the extraction directory.
    local EXTRACT="build-$ARCHIVE"
    push_directory "$BUILD_DIR"
    create_directory "$EXTRACT"
    push_directory "$EXTRACT"

    # Extract the source locally.
    wget --output-document "$ARCHIVE" "$URL"
    tar --extract --file "$ARCHIVE" "--$COMPRESSION" --strip-components=1

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
  # display_message "-sICU_LINK            : " "${ICU_LIBS[*]}"
    display_message "-j                    : $JOBS"
    display_message "-d0                   : [supress informational messages]"
    display_message "-q                    : [stop at the first error]"
    display_message "--reconfigure         : [ignore cached configuration]"
    display_message "--prefix              : $PREFIX"
    display_message "BOOST_OPTIONS         : $*"
    display_message "--------------------------------------------------------------------"

    ./bootstrap.sh \\
        "--prefix=$PREFIX" \\
        "--with-icu=$ICU_PREFIX"

    # boost_regex:
    # As of boost 1.72.0 the ICU_LINK symbol is no longer supported and
    # produces a hard stop if WITH_ICU is also defined. Removal is sufficient.
    # github.com/libbitcoin/libbitcoin-system/issues/1192
    # "-sICU_LINK=${ICU_LIBS[*]}"

    ./b2 install \\
        "cxxstd=11" \\
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
        "-j $JOBS" \\
        "-d0" \\
        "-q" \\
        "--reconfigure" \\
        "--prefix=$PREFIX" \\
        "$@"

    pop_directory
    pop_directory

    IFS="$SAVE_IFS"
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
    git clone --depth 1 --branch "$BRANCH" --single-branch "https://github.com/$FORK"

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    # Build the local repository clone.
    push_directory "$REPO"
    make_current_directory "$JOBS" "${CONFIGURATION[@]}"
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
    make_current_directory "$JOBS" "${CONFIGURATION[@]}"
}

.endmacro # define_build_from_local
.
.macro define_build_from_ci()
# Because continuous integration services has downloaded the primary repository.
build_from_ci()
{
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    local JOBS=$4
    local OPTIONS=$5
    shift 5

    # The primary build is not downloaded if we are running on a continuous integration system.
    if [[ $CI == true ]]; then
        build_from_local "Local $CI_REPOSITORY" "$JOBS" "${OPTIONS[@]}" "$@"
        make_tests "$JOBS"
    else
        build_from_github "$ACCOUNT" "$REPO" "$BRANCH" "$JOBS" "${OPTIONS[@]}" "$@"
        push_directory "$BUILD_DIR"
        push_directory "$REPO"
        make_tests "$JOBS"
        pop_directory
        pop_directory
    fi
}

.endmacro # define_build_from_ci
.
.macro define_build_functions()
.   define_initialize_icu_packages()
.   define_build_from_tarball()
.   define_boost_build_configuration_helpers()
.   define_build_from_tarball_boost()
.   define_build_from_github()
.   define_build_from_local()
.   define_build_from_ci()
.endmacro # define_build_functions
.
.macro build_from_tarball_icu()
    build_from_tarball "$ICU_URL" "$ICU_ARCHIVE" gzip source "$PARALLEL" "$BUILD_ICU" "${ICU_OPTIONS[@]}" "$@"
.endmacro # build_icu
.
.macro build_from_tarball_zmq()
    build_from_tarball "$ZMQ_URL" "$ZMQ_ARCHIVE" gzip . "$PARALLEL" "$BUILD_ZMQ" "${ZMQ_OPTIONS[@]}" "$@"
.endmacro # build_zmq
.
.macro build_from_tarball_mbedtls()
    build_from_tarball "$MBEDTLS_URL" "$MBEDTLS_ARCHIVE" gzip . "$PARALLEL" "$BUILD_MBEDTLS" "${MBEDTLS_OPTIONS[@]}" "$@"
.endmacro # build_mbedtls
.
.macro build_boost()
    build_from_tarball_boost "$BOOST_URL" "$BOOST_ARCHIVE" bzip2 . "$PARALLEL" "$BUILD_BOOST" "${BOOST_OPTIONS[@]}"
.endmacro # build_boost
.
.macro build_github(build)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    build_from_github $(my.build.github) $(my.build.repository) $(my.build.branch) "$(my.parallel)" "$(my.options)" "$@"
.endmacro # build_github
.
.macro build_ci(build)
.   define my.build = build_ci.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    build_from_ci $(my.build.github) $(my.build.repository) $(my.build.branch) "$(my.parallel)" "$(my.options)" "$@"
.endmacro # build_ci
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
.                   build_ci(_build)
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
display_configuration
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
function generate_installer(path_prefix)
    for generate.repository by name as _repository
        require(_repository, "repository", "name")
        my.output_path = join(my.path_prefix, canonical_path_name(_repository))
        define my.out_file = "$(my.output_path)/install.sh"
        create_directory(my.output_path)
        notify(my.out_file)
        output(my.out_file)

        new install as _install
            cumulative_install(_install, generate, _repository)

            shebang("bash")

            copyleft(_repository.name)
            documentation(_repository, _install)

            heading1("Define constants.")
            define_build_directory(_repository)
            define_icu(_install)
            define_zmq(_install)
            define_mbedtls(_install)
            define_boost(_install)

            heading1("Define utility functions.")
            define_utility_functions()
            define_help(_repository, _install, "install")

            heading1("Define environment initialization functions")
            define_parse_command_line_options(_repository, _install)
            define_handle_help_line_option()
            define_set_operating_system()
            define_parallelism()
            define_set_os_specific_compiler_settings()
            define_link_to_standard_library()
            define_normalized_configure_options()
            define_handle_custom_options()
            define_remove_build_options()
            define_set_prefix()
            define_set_pkgconfigdir()
            define_set_with_boost_prefix()
            define_display_configuration(_repository, _install)

            heading1("Define build functions.")
            define_build_functions()

            heading1("The master build function.")
            define_build_all(_install)

            heading1("Initialize the build environment.")
            define_initialization_calls()

            heading1("Define build options.")
            for _install.build as _build where count(_build.option) > 0
                define_build_options(_build)
            endfor _build

            heading1("Build the primary library and all dependencies.")
            define_invoke()

        endnew _install
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
