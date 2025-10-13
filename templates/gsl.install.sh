.template 0
###############################################################################
# Copyright (c) 2014-2025 libbitcoin developers (see COPYING).
#
# GSL generate install.sh.
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
    display_message "BUILD_SRC_DIR          : $BUILD_SRC_DIR"
.endmacro # custom_configuration
.
.macro custom_script_options()
            # Unique script options.
            (--build-dir=*)    BUILD_SRC_DIR="${OPTION#*=}";;
.endmacro # custom_script_options
.
.macro define_build_variables_custom(repository)
.   define my.repo = define_build_variables_custom.repository
.   heading2("The default build directory.")
BUILD_SRC_DIR="build-$(my.repo.name)"

PRESUMED_CI_PROJECT_PATH=\$(pwd)

.endmacro # define_build_variables_custom
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
.macro define_make_jobs()
# make_jobs jobs [make_options]
make_jobs()
{
    local JOBS=$1
    shift 1

    VERBOSITY=""
    if [[ $DISPLAY_VERBOSE ]]; then
        VERBOSITY="VERBOSE=1"
    fi

    SEQUENTIAL=1
    # Avoid setting -j1 (causes problems on single threaded systems [TRAVIS]).
    if [[ $JOBS -gt $SEQUENTIAL ]]; then
        make -j"$JOBS" "$@" $VERBOSITY
    else
        make "$@" $VERBOSITY
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
.macro define_build_functions(install)
.   define my.install = define_build_functions.install
.   define_tarball_functions("false", "true")
.   define_github_functions()
.   if (count(my.install.build, count.name = "boost") > 0)
.       define my.build = my.install->build(name = "boost")
.       define_boost_build_functions(my.build)
.   endif
.endmacro # define_build_functions
.
.macro build_from_tarball_icu()
    unpack_from_tarball "$ICU_ARCHIVE" "$ICU_URL" gzip "$BUILD_ICU"
    local SAVE_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS ${ICU_FLAGS[@]}"
    build_from_tarball "$ICU_ARCHIVE" source "$PARALLEL" "$BUILD_ICU" "${ICU_OPTIONS[@]}" "$@"
    export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_icu
.
.macro build_from_tarball_zmq()
    unpack_from_tarball "$ZMQ_ARCHIVE" "$ZMQ_URL" gzip "$BUILD_ZMQ"
    local SAVE_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS ${ZMQ_FLAGS[@]}"
    build_from_tarball "$ZMQ_ARCHIVE" . "$PARALLEL" "$BUILD_ZMQ" "${ZMQ_OPTIONS[@]}" "$@"
    export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_zmq
.
.macro build_boost()
    unpack_from_tarball "$BOOST_ARCHIVE" "$BOOST_URL" bzip2 "$BUILD_BOOST"
    local SAVE_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS ${BOOST_FLAGS[@]}"
    build_from_tarball_boost "$BOOST_ARCHIVE" "$PARALLEL" "$BUILD_BOOST" "${BOOST_OPTIONS[@]}"
    export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_boost
.
.macro build_github(build)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.conditional = get_conditional_parameter(my.build)
.   define my.flags = "${$(my.build.name:upper,c)_FLAGS[@]}"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
.   define my.branch = "${$(my.build.name:upper,c)_BRANCH}"
    create_from_github $(my.build.github) $(my.build.repository) $(my.branch) "$(my.conditional)"
    local SAVE_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS $(my.flags)"
    build_from_github $(my.build.repository) "$(my.parallel)" false "$(my.conditional)" "$(my.options)" "$@"
    export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_github
.
.macro build_ci(build)
.   define my.build = build_ci.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.conditional = get_conditional_parameter(my.build)
.   define my.flags = "${$(my.build.name:upper,c)_FLAGS[@]}"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
.   define my.branch = "${$(my.build.name:upper,c)_BRANCH}"
    local SAVE_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS $(my.flags)"
    if [[ ! ($CI == true) ]]; then
        create_from_github $(my.build.github) $(my.build.repository) $(my.branch) "$(my.conditional)"
        build_from_github $(my.build.repository) "$(my.parallel)" true "$(my.conditional)" "$(my.options)" "$@"
    else
        push_directory "$PRESUMED_CI_PROJECT_PATH"
        push_directory ".."
        build_from_github $(my.build.repository) "$(my.parallel)" true "$(my.conditional)" "$(my.options)" "$@"
        pop_directory
        pop_directory
    fi
    export CPPFLAGS=$SAVE_CPPFLAGS
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

if [[ ! ($CI == true) ]]; then
    create_directory "$BUILD_SRC_DIR"
    push_directory "$BUILD_SRC_DIR"
else
    push_directory "$BUILD_SRC_DIR"
fi

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
function generate_installer(path_prefix)
    define my.integration = generate->integration
    for generate.repository by name as _repository
        require(_repository, "repository", "name")
        my.output_path = join(my.path_prefix, canonical_path_name(_repository))
        define my.out_file = "$(my.output_path)/install.sh"
        create_directory(my.output_path)
        notify(my.out_file)
        output(my.out_file)

        new configuration as _config
        new install as _install
            cumulative_install(_install, generate, _repository)

            shebang("bash")

            copyleft(_repository.name)
            documentation(_repository, _install)

            heading1("Define constants.")
            define_github_branches(_install)
            define_build_variables(_repository)
            define_icu(_install)
            define_zmq(_install)
            define_boost(_install)

            heading1("Define utility functions.")
            define_utility_functions()
            define_help(_repository, _install, "install")

            heading1("Define environment initialization functions")
            define_parse_command_line_options(_repository, _install)
            define_handle_help_line_option()
            define_set_operating_system()
            define_parallelism()
            define_set_os_specific_compiler_settings(my.integration)
            define_link_to_standard_library()
            define_normalized_configure_options()
            define_handle_custom_options()
            define_remove_build_options()
            define_set_prefix()
            define_set_pkgconfigdir(_config)
            define_set_with_boost_prefix(_config)
            define_display_configuration(_repository, _install)

            heading1("Define build functions.")
            define_build_functions(_install)

            heading1("The master build function.")
            define_build_all(_install)

            heading1("Initialize the build environment.")
            define_initialization_calls()

            heading1("Define build flags.")
            for _install.build as _build where count(_build.flag) > 0
                define_build_flags(_config, _build)
            endfor _build

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
