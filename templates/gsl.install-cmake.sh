.template 0
###############################################################################
# Copyright (c) 2014-2020 libbitcoin developers (see COPYING).
#
# GSL generate install-cmake.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

function test_perform_sync()
    return "true"
endfunction

function test_perform_configure()
    return "true"
endfunction

function test_perform_build()
    return "true"
endfunction

function test_produce_dependencies()
    return "true"
endfunction

function test_produce_libbitcoin()
    return "true"
endfunction

function test_produce_project()
    return "true"
endfunction

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
    display_message "BUILD_DIR                      : $BUILD_DIR"
    display_message "CUMULATIVE_FILTERED_ARGS       : $CUMULATIVE_FILTERED_ARGS"
    display_message "CUMULATIVE_FILTERED_ARGS_CMAKE : $CUMULATIVE_FILTERED_ARGS_CMAKE"
.endmacro # custom_configuration
.
.macro custom_script_options()
            # Unique script options.
            (--build-dir=*)         BUILD_DIR="${OPTION#*=}";;

            # Handle ndebug declarations due to disabled argument passthrough
            (--enable-ndebug)       ENABLE_NDEBUG="yes";;
            (--disable-ndebug)      DISABLE_NDEBUG="yes";;

.endmacro # custom_script_options
.
.macro define_build_variables_custom(repository)
.   define my.repo = define_build_variables_custom.repository
.   heading2("The default build directory.")
BUILD_DIR="build-$(my.repo.name)"

.   heading2("Git clone parameters.")
GIT_CLONE_PARAMS="--depth 1 --single-branch"

PRESUMED_CI_PROJECT_PATH=\$(pwd)

.endmacro # define_build_variables_custom
.
.macro define_handle_custom_options(install)
.   define my.install = define_handle_custom_options.install
handle_custom_options()
{
    CUMULATIVE_FILTERED_ARGS=""
    CUMULATIVE_FILTERED_ARGS_CMAKE=""

    if [[ $ENABLE_NDEBUG && $DISABLE_NDEBUG ]]; then
        display_error "--enable-ndebug and --disable-ndebug are mutually exclusive options."
        display_error ""
        exit 1
    elif [[ $DISABLE_NDEBUG ]]; then
        CUMULATIVE_FILTERED_ARGS="--disable-ndebug"
        CUMULATIVE_FILTERED_ARGS_CMAKE="-Denable-ndebug=no"
    else
        CUMULATIVE_FILTERED_ARGS="--enable-ndebug"
        CUMULATIVE_FILTERED_ARGS_CMAKE="-Denable-ndebug=yes"
    fi

    # Process link declaration
    if [[ $DISABLE_SHARED ]]; then
        CUMULATIVE_FILTERED_ARGS+=" --enable-static --disable-shared"
        CUMULATIVE_FILTERED_ARGS_CMAKE+=" -DBUILD_SHARED_LIBS=FALSE"
    elif [[ $DISABLE_STATIC ]]; then
        CUMULATIVE_FILTERED_ARGS+=" --disable-static --enable-shared"
        CUMULATIVE_FILTERED_ARGS_CMAKE+=" -DBUILD_SHARED_LIBS=TRUE"
    fi

    # Process prefix
    if [[ ($PREFIX) ]]; then
        CUMULATIVE_FILTERED_ARGS+=" --prefix=\"${PREFIX}\""
        CUMULATIVE_FILTERED_ARGS_CMAKE+=" -DCMAKE_PREFIX_PATH=\"${PREFIX}\" -DCMAKE_INSTALL_PREFIX=\"${PREFIX}\""

        if [ -z $CMAKE_INCLUDE_PATH ]; then
            export CMAKE_INCLUDE_PATH="${PREFIX}/include"
        else
            export CMAKE_INCLUDE_PATH="${PREFIX}/include:${CMAKE_INCLUDE_PATH}"
        fi

        if [ -z $CMAKE_LIBRARY_PATH ]; then
            export CMAKE_LIBRARY_PATH="${PREFIX}/lib"
        else
            export CMAKE_LIBRARY_PATH="${PREFIX}/lib:${CMAKE_LIBRARY_PATH}"
        fi
    fi
.
.   if (have_build(my.install, "icu"))

    # Process ICU
    if [[ $WITH_ICU ]]; then
        CUMULATIVE_FILTERED_ARGS+=" --with-icu"
        CUMULATIVE_FILTERED_ARGS_CMAKE+=" -Dwith-icu=yes"
    fi
.   endif
.   if (have_build(my.install, "mbedtls"))

    # Process MBEDTLS
    if [[ $WITH_MBEDTLS ]]; then
        CUMULATIVE_FILTERED_ARGS+=" --with-mbedtls"
        CUMULATIVE_FILTERED_ARGS_CMAKE+=" -Dwith-mbedtls=yes"
    fi
.   endif
.
}

.endmacro # define_handle_custom_options()
.
.macro define_remove_install_options()
remove_install_options()
{
    # Purge installer handled options other than --build-.
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--with-*/}")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--enable-*/}")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--disable-*/}")
    CONFIGURE_OPTIONS=("${CONFIGURE_OPTIONS[@]/--prefix=*/}")
}

.endmacro # define_remove_install_options()
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
.macro define_make_project_directory()
# make_project_directory project_name jobs [configure_options]
make_project_directory()
{
    local PROJ_NAME=$1
    local JOBS=$2
    local TEST=$3
    shift 3

    push_directory "$PROJ_NAME"
    local PROJ_CONFIG_DIR
    PROJ_CONFIG_DIR=\$(pwd)

    ./autogen.sh

    configure_options "$@"
    make_jobs "$JOBS"

    if [[ $TEST == true ]]; then
        make_tests "$JOBS"
    fi

    make install
    configure_links
    pop_directory
}

.endmacro # define_make_project_directory
.
.macro define_cmake_analogous_functions()
cmake_tests()
{
    local JOBS=$1

    disable_exit_on_error

    # Build and run unit tests relative to the primary directory.
    # VERBOSE=1 ensures test runner output sent to console (gcc).
    make -j"$JOBS" test "VERBOSE=1"
    local RESULT=$?

    # Test runners emit to the test.log file.
    if [[ -e "test.log" ]]; then
        cat "test.log"
    fi

    if [[ $RESULT -ne 0 ]]; then
        exit $RESULT
    fi

    enable_exit_on_error
}

cmake_project_directory()
{
    local PROJ_NAME=$1
    local JOBS=$2
    local TEST=$3
    shift 3

    push_directory "$PROJ_NAME"
    local PROJ_CONFIG_DIR
    PROJ_CONFIG_DIR=\$(pwd)

    cmake $CMAKE_LINK_ARGS $CMAKE_PREFIX_ARGS $@ builds/cmake
    make_jobs "$JOBS"

    if [[ $TEST == true ]]; then
        cmake_tests "$JOBS"
    fi

    make install
    configure_links
    pop_directory
}

build_from_github_cmake()
{
    local REPO=$1
    local JOBS=$2
    local TEST=$3
    local OPTIONS=$4
    shift 4

    # Join generated and command line options.
    local CONFIGURATION=("${OPTIONS[@]}" "$@")

    display_heading_message "Prepairing to build $REPO"

    # Build the local repository clone.
    cmake_project_directory "$REPO" "$JOBS" "$TEST" "${CONFIGURATION[@]}"
}

.endmacro # define_cmake_analogous_functions
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
.   define_configure_options("true")
.   define_create_directory("true")
.   define_display_functions()
.   define_initialize_git()
.   define_make_project_directory()
.   define_make_jobs()
.   define_make_tests("false")
.   define_push_pop_directory()
.   define_enable_exit_on_error()
.   define_disable_exit_on_error()
.endmacro # define_utility_functions
.
.macro define_build_functions()
.   define_tarball_functions("false", "true")
.   define_github_functions()
.   define_cmake_analogous_functions()
.   define_boost_build_functions()
.endmacro # define_build_functions
.
.macro build_from_tarball_icu()
    unpack_from_tarball "$ICU_ARCHIVE" "$ICU_URL" gzip "$BUILD_ICU"
    build_from_tarball "$ICU_ARCHIVE" source "$PARALLEL" "$BUILD_ICU" "${ICU_OPTIONS[@]}" $CUMULATIVE_FILTERED_ARGS
.endmacro # build_icu
.
.macro build_from_tarball_zmq()
    unpack_from_tarball "$ZMQ_ARCHIVE" "$ZMQ_URL" gzip "$BUILD_ZMQ"
    build_from_tarball "$ZMQ_ARCHIVE" . "$PARALLEL" "$BUILD_ZMQ" "${ZMQ_OPTIONS[@]}" $CUMULATIVE_FILTERED_ARGS
.endmacro # build_zmq
.
.macro build_from_tarball_mbedtls()
    unpack_from_tarball "$MBEDTLS_ARCHIVE" "$MBEDTLS_URL" gzip "$BUILD_MBEDTLS"
    build_from_tarball "$MBEDTLS_ARCHIVE" . "$PARALLEL" "$BUILD_MBEDTLS" "${MBEDTLS_OPTIONS[@]}" $CUMULATIVE_FILTERED_ARGS
.endmacro # build_mbedtls
.
.macro build_boost()
    unpack_from_tarball "$BOOST_ARCHIVE" "$BOOST_URL" bzip2 "$BUILD_BOOST"
    build_from_tarball_boost "$BOOST_ARCHIVE" "$PARALLEL" "$BUILD_BOOST" "${BOOST_OPTIONS[@]}"
.endmacro # build_boost
.
.macro build_github(build)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    create_from_github $(my.build.github) $(my.build.repository) $(my.build.branch)
.   if (is_bitcoin_dependency(my.build))
    build_from_github_cmake $(my.build.repository) "$(my.parallel)" false "$(my.options)" $CUMULATIVE_FILTERED_ARGS_CMAKE "$@"
.   else
    build_from_github $(my.build.repository) "$(my.parallel)" false "$(my.options)" $CUMULATIVE_FILTERED_ARGS
.   endif
.endmacro # build_github
.
.macro build_github_cmake(build)
.   define my.build = build_github_cmake.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    create_from_github $(my.build.github) $(my.build.repository) $(my.build.branch)
    build_from_github_cmake $(my.build.repository) "$(my.parallel)" false "$(my.options)" $CUMULATIVE_FILTERED_ARGS_CMAKE "$@"
.endmacro # build_github_cmake
.
.macro build_ci(build)
.   define my.build = build_ci.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
    if [[ ! ($CI == true) ]]; then
        create_from_github $(my.build.github) $(my.build.repository) $(my.build.branch)
.   if (is_bitcoin_dependency(my.build))
        build_from_github_cmake $(my.build.repository) "$(my.parallel)" true "$(my.options)" $CUMULATIVE_FILTERED_ARGS_CMAKE "$@"
.   else
        build_from_github $(my.build.repository) "$(my.parallel)" true "$(my.options)" $CUMULATIVE_FILTERED_ARGS
.   endif
    else
        push_directory "$PRESUMED_CI_PROJECT_PATH"
        push_directory ".."
        build_from_github_cmake $(my.build.repository) "$(my.parallel)" true "$(my.options)" $CUMULATIVE_FILTERED_ARGS_CMAKE "$@"
        pop_directory
        pop_directory
    fi
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
time build_all "${CONFIGURE_OPTIONS[@]}"
pop_directory
.endmacro # define_invoke
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_installer_cmake(path_prefix)
    for generate.repository by name as _repository
        require(_repository, "repository", "name")
        my.output_path = join(my.path_prefix, canonical_path_name(_repository))
        define my.out_file = "$(my.output_path)/install-cmake.sh"
        create_directory(my.output_path)
        notify(my.out_file)
        output(my.out_file)

        new configuration as _config
        new install as _install
            _config.cmake = "true"
            cumulative_install(_install, generate, _repository)

            shebang("bash")

            copyleft(_repository.name)
            documentation(_repository, _install)

            heading1("Define constants.")
            define_build_variables(_repository)
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
            define_handle_custom_options(_install)
            define_remove_build_options()
            define_remove_install_options()
            define_set_prefix()
            define_set_pkgconfigdir(_config)
            define_set_with_boost_prefix(_config)
            define_display_configuration(_repository, _install)

            heading1("Define build functions.")
            define_build_functions()

            heading1("The master build function.")
            define_build_all(_install)

            heading1("Initialize the build environment.")
            define_initialization_calls()
            write_line("remove_install_options")

            heading1("Define build options.")
            for _install.build as _build where count(_build.option) > 0
                define_build_options(_config, _build)
            endfor _build

            heading1("Build the primary library and all dependencies.")
            define_invoke()

        endnew _install
        endnew _config
        close
    endfor _repository
endfunction # generate_installer_cmake
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

generate_installer_cmake("output")

.endtemplate
