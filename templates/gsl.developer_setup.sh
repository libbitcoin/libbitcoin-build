.template 0
###############################################################################
# Copyright (c) 2014-2025 libbitcoin developers (see COPYING).
#
# GSL generate developer_setup.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

# common BUILD_MODE related query strings.

function test_perform_sync()
    return "($BUILD_MODE == \"sync\")"
endfunction

function test_perform_configure()
    return "($BUILD_MODE == \"sync\") || ($BUILD_MODE == \"configure\")"
endfunction

function test_perform_build()
    return "true"
endfunction

function test_produce_dependencies()
    return "($BUILD_TARGET == \"all\") || ($BUILD_TARGET == \"dependencies\")"
endfunction

function test_produce_libbitcoin()
    return "($BUILD_TARGET == \"all\") || ($BUILD_TARGET == \"libbitcoin\")"
endfunction

function test_produce_project()
    return "($BUILD_TARGET == \"all\") || ($BUILD_TARGET == \"project\")"
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro custom_help(repository, install, script_name)
    display_message "  --build-mode=<value>     Specifies minimum action to be taken."
    display_message "                             Valid values: { sync, configure, build }."
    display_message "                             Defaults to 'unknown', must be declared."
    display_message "  --build-target=<value>   Specifies the targets to be acted upon."
    display_message "                             Valid values: { all, dependencies, libbitcoin, project }."
    display_message "                             Defaults to 'unknown', must be declared."
    display_message "  --build-src-dir=<path>   Location of downloaded and intermediate files."
    display_message "                             Has no default, required."
    display_message "  --build-obj-dir=<path>   Location of intermediate object files."
    display_message "                             Has no default, required."
    display_message "  --build-sync-only        Restrict actions to syncing necessary targets."
    display_message "  --build-tag=<value>      Use as branch for libbitcoin projects."
.endmacro # custom_help
.
.macro custom_documentation(repository, install)
# --build-mode=<value>     Specifies minimum action to be taken.
#                            Valid values: { sync, configure, build }.
# --build-target=<value>   Specifies the targets to be acted upon.
#                            Valid values: { all, dependencies, libbitcoin, project }.
# --build-src-dir=<path>   Location of downloaded and intermediate files.
# --build-obj-dir=<path>   Location of intermediate object files.
# --build-sync-only        Restrict actions to syncing necessary targets.
.endmacro # custom_documentation
.
.macro custom_configuration(repository, install)
    display_message "BUILD_SRC_DIR         : $BUILD_SRC_DIR"
    display_message "BUILD_OBJ_DIR         : $BUILD_OBJ_DIR"
    display_message "BUILD_MODE            : $BUILD_MODE"
    display_message "BUILD_TARGET          : $BUILD_TARGET"
    display_message "SYNC_ONLY             : $SYNC_ONLY"
.endmacro # custom_configuration
.
.macro custom_script_options()
            # Unique script options.
            (--build-src-dir=*)     BUILD_SRC_DIR="${OPTION#*=}";;
            (--build-obj-dir=*)     BUILD_OBJ_DIR="${OPTION#*=}";;
            (--build-mode=*)        BUILD_MODE="${OPTION#*=}";;
            (--build-target=*)      BUILD_TARGET="${OPTION#*=}";;
            (--build-sync-only)     SYNC_ONLY="yes";;
            (--build-tag=*)         BUILD_TAG="${OPTION#*=}";;
.endmacro # custom_script_options
.
.macro define_build_variables_custom(repository)
.   heading2("The default source directory.")
BUILD_SRC_DIR=""

.   heading2("The default objects directory.")
BUILD_OBJ_DIR=""

.   heading2("The default build mode (sync, configure, build).")
BUILD_MODE="unknown"

.   heading2("The default build target (all, dependencies, libbitcoin, project).")
BUILD_TARGET="unknown"

.
.endmacro # define_build_variables_custom
.
.macro define_handle_custom_options(install)
.   define my.install = define_handle_custom_options.install
.   heading2("Process script specific options.")
handle_custom_options()
{
    if [[ ($BUILD_MODE != "sync") && ($BUILD_MODE != "configure") && ($BUILD_MODE != "build") ]]; then
        display_error "Unsupported build-mode: $BUILD_MODE"
        display_error "Supported values are: sync, configure, build"
        display_error ""
        display_help
        exit 1
    fi

    if [[ ($BUILD_TARGET != "all") && ($BUILD_TARGET != "dependencies") && ($BUILD_TARGET != "libbitcoin") && ($BUILD_TARGET != "project") ]]; then
        display_error "Unsupported build-target: $BUILD_TARGET"
        display_error "Supported values are: all, dependencies, libbitcoin, project"
        display_error ""
        display_help
        exit 1
    fi

    if [[ ! ($BUILD_SRC_DIR) ]]; then
        display_error "Missing build-src-dir required."
        display_error ""
        display_help
        exit 1
    fi

    if [[ ! ($BUILD_OBJ_DIR) ]]; then
        display_error "Missing build-obj-dir required."
        display_error ""
        display_help
        exit 1
    fi

    if [[ $BUILD_TAG ]]; then
.   for my.install.build as _build where defined(_build.branch)
.       if (starts_with(_build.name, "bitcoin-") & (is_github_build(_build)) & starts_with("libbitcoin", _build.github))
        $(_build.name:upper,c)_BRANCH=${BUILD_TAG}
.       endif
.   endfor
    fi
}

.endmacro # define_handle_custom_options
.
.macro define_configure_options()
configure_options()
{
    local PROJ_CONFIG_DIR=$1
    shift

    display_message "configure options:"
    for OPTION in "$@"; do
        if [[ $OPTION ]]; then
            display_message "$OPTION"
        fi
    done

    if [[ -f "Makefile" ]]; then
        if [[ $(test_perform_configure()) ]]; then
            display_message "Reconfiguring $PROJ_CONFIG_DIR..."
            "$PROJ_CONFIG_DIR/configure" "$@"
        else
            display_message "Reusing configuration for $PROJ_CONFIG_DIR..."
        fi
    else
        display_message "Configuring $PROJ_CONFIG_DIR..."
        "$PROJ_CONFIG_DIR/configure" "$@"
    fi
}

.endmacro # define_configure_options
.
.macro define_create_directory()
create_directory()
{
    local DIRECTORY="$1"

    if [[ -d "$DIRECTORY" ]]; then
        if [[ $(test_perform_sync()) ]]; then
            display_message "Reinitializing directory $DIRECTORY..."
            rm -rf "$DIRECTORY"
            mkdir "$DIRECTORY"
        else
            display_message "Reusing directory $DIRECTORY..."
        fi
    else
        display_message "Initializing directory $DIRECTORY..."
        mkdir "$DIRECTORY"
    fi
}

.endmacro # define_create_directory
.
.macro define_push_pop_obj_directory
push_obj_directory()
{
    local PROJ_NAME="$1"
    shift

    push_directory "$BUILD_OBJ_DIR"
    create_directory "$PROJ_NAME"
    push_directory "$PROJ_NAME"
}

pop_obj_directory()
{
    pop_directory
    pop_directory
}

.endmacro # define_push_pop_obj_directory
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

    if [[ -f "$PROJ_NAME/configure" ]]; then
        if [[ $BUILD_MODE != "reuse" ]]; then
            # reconfigure using autoreconf
            autoreconf -i
        fi
    else
        # boostrap configuration
        ./autogen.sh
    fi

    push_obj_directory "$PROJ_NAME"
    configure_options "$PROJ_CONFIG_DIR" "$@"
    make_jobs true "$JOBS"

    if [[ $TEST == true ]]; then
        make_tests "$JOBS"
    fi

    make install
    configure_links
    pop_obj_directory
    pop_directory
}

.endmacro # define_make_project_directory
.
.macro define_make_jobs()
# make_jobs jobs [make_options]
make_jobs()
{
    local PRECLEAN=$1
    local JOBS=$2
    shift 2

    if [[ $PRECLEAN == true ]]; then
        display_message "Requested 'make clean'..."
        make clean
    fi

    # Avoid setting -j1 (causes problems on Travis).
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
.   define_push_pop_obj_directory()
.   define_display_functions()
.   define_initialize_git()
.   define_make_project_directory()
.   define_make_jobs()
.   define_make_tests("true")
.   define_push_pop_directory()
.   define_enable_exit_on_error()
.   define_disable_exit_on_error()
.endmacro # define_utility_functions
.
.macro define_build_functions(install)
.   define my.install = define_build_functions.install
.   define_tarball_functions("true")
.   define_github_functions()
.   if (count(my.install.build, count.name = "boost") > 0)
.       define my.build = my.install->build(name = "boost")
.       define_boost_build_functions(my.build)
.   endif
.   define_initialize_object_directory()
.endmacro # define_build_functions
.
.macro unpack_from_tarball_icu(prefix)
$(my.prefix)unpack_from_tarball $ICU_ARCHIVE $ICU_URL gzip "$BUILD_ICU"
.endmacro # unpack_from_tarball_icu
.
.macro build_from_tarball_icu(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${ICU_FLAGS[@]}"
$(my.prefix)build_from_tarball $ICU_ARCHIVE source "$PARALLEL" "$BUILD_ICU" "${ICU_OPTIONS[@]}" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_from_tarball_icu
.
.macro unpack_from_tarball_zlib(prefix)
$(my.prefix)unpack_from_tarball $ZLIB_ARCHIVE $ZLIB_URL gzip "$BUILD_ZLIB"
.endmacro # unpack_from_tarball_zlib
.
.macro build_from_tarball_zlib(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${ZLIB_FLAGS[@]}"
$(my.prefix)build_from_tarball $ZLIB_ARCHIVE . "$PARALLEL" "$BUILD_ZLIB" "${ZLIB_OPTIONS[@]}" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_from_tarball_zlib
.
.macro unpack_from_tarball_png(prefix)
$(my.prefix)unpack_from_tarball $PNG_ARCHIVE $PNG_URL xz "$BUILD_PNG"
.endmacro # unpack_from_tarball_png
.
.macro build_from_tarball_png(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${PNG_FLAGS[@]}"
$(my.prefix)build_from_tarball $PNG_ARCHIVE . "$PARALLEL" "$BUILD_PNG" "${PNG_OPTIONS[@]}" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_from_tarball_png
.
.macro unpack_from_tarball_qrencode(prefix)
$(my.prefix)unpack_from_tarball $QRENCODE_ARCHIVE $QRENCODE_URL bzip2 "$BUILD_QRENCODE"
.endmacro # unpack_from_tarball_qrencode
.
.macro build_from_tarball_qrencode(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${QRENCODE_FLAGS[@]}"
$(my.prefix)build_from_tarball $QRENCODE_ARCHIVE . "$PARALLEL" "$BUILD_QRENCODE" "${QRENCODE_OPTIONS[@]}" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_from_tarball_qrencode
.
.macro unpack_from_tarball_zmq(prefix)
$(my.prefix)unpack_from_tarball $ZMQ_ARCHIVE $ZMQ_URL gzip "$BUILD_ZMQ"
.endmacro # unpack_from_tarball_zmq
.
.macro build_from_tarball_zmq(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${ZMQ_FLAGS[@]}"
$(my.prefix)build_from_tarball $ZMQ_ARCHIVE . $PARALLEL "$BUILD_ZMQ" "${ZMQ_OPTIONS[@]}" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_from_tarball_zmq
.
.macro unpack_boost(prefix)
$(my.prefix)unpack_from_tarball $BOOST_ARCHIVE $BOOST_URL bzip2 "$BUILD_BOOST"
.endmacro # unpack_boost
.
.macro build_boost(prefix)
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS ${BOOST_FLAGS[@]}"
$(my.prefix)build_from_tarball_boost $BOOST_ARCHIVE "$PARALLEL" "$BUILD_BOOST" "${BOOST_OPTIONS[@]}"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_boost
.
.macro create_github(build, prefix)
.   define my.build = create_github.build
.   define my.conditional = get_conditional_parameter(my.build)
.   define my.branch = "${$(my.build.name:upper,c)_BRANCH}"
$(my.prefix)create_from_github $(my.build.github) $(my.build.repository) $(my.branch) "$(my.conditional)"
.endmacro # create_github
.
.macro build_github(build, prefix)
.   define my.build = build_github.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.conditional = get_conditional_parameter(my.build)
.   define my.flags = "${$(my.build.name:upper,c)_FLAGS[@]}"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS $(my.flags)"
$(my.prefix)build_from_github $(my.build.repository) "$(my.parallel)" false "$(my.conditional)" "$(my.options)" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_github_test
.
.macro build_github_test(build, prefix)
.   define my.build = build_github_test.build
.   define my.parallel = is_true(my.build.parallel) ?? "$PARALLEL" ? "$SEQUENTIAL"
.   define my.conditional = get_conditional_parameter(my.build)
.   define my.flags = "${$(my.build.name:upper,c)_FLAGS[@]}"
.   define my.options = "${$(my.build.name:upper,c)_OPTIONS[@]}"
local SAVE_CPPFLAGS="$CPPFLAGS"
export CPPFLAGS="$CPPFLAGS $(my.flags)"
$(my.prefix)build_from_github $(my.build.repository) "$(my.parallel)" true "$(my.conditional)" "$(my.options)" "$@"
export CPPFLAGS=$SAVE_CPPFLAGS
.endmacro # build_github_test
.
.macro define_create_local_copies(install)
.   define my.install = define_create_local_copies.install
.   define my.prefix = "        "
create_local_copies()
{
    display_heading_message "Create local copies of required libraries"
.   for my.install.build as _build
.       # Unique by build.name
.       if !defined(my.build_$(_build.name:c))
.           define my.build_$(_build.name:c) = 0
.
.           if (is_icu_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               unpack_from_tarball_icu(my.prefix)
    fi
.           elsif (is_zmq_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               unpack_from_tarball_zmq(my.prefix)
    fi
.           elsif (is_boost_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               unpack_boost(my.prefix)
    fi
.           elsif (is_github_build(_build))
.               if (!last())
.                   if (starts_with(_build.repository, "libbitcoin"))
    if [[ $(test_produce_libbitcoin()) ]]; then
.                   else
    if [[ $(test_produce_dependencies()) ]]; then
.                   endif
.               else
    if [[ $(test_produce_project()) ]]; then
.               endif
.               create_github(_build, my.prefix)
    fi
.           else
.               abort "Invalid build type: $(_build.name)."
.           endif
.
.       endif
.   endfor _build
}

.endmacro # define_create_local_copies
.
.macro define_build_local_copies(install)
.   define my.install = define_build_local_copies.install
.   define my.prefix = "        "
build_local_copies()
{
    display_heading_message "Build local copies of required libraries"
.   for my.install.build as _build
.       # Unique by build.name
.       if !defined(my.build_$(_build.name:c))
.           define my.build_$(_build.name:c) = 0
.
.           if (is_icu_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               build_from_tarball_icu(my.prefix)
    fi
.           elsif (is_zmq_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               build_from_tarball_zmq(my.prefix)
    fi
.           elsif (is_boost_build(_build))
    if [[ $(test_produce_dependencies()) ]]; then
.               build_boost(my.prefix)
    fi
.           elsif (is_github_build(_build))
.               if (!last())
.                   if (starts_with(_build.repository, "libbitcoin"))
    if [[ $(test_produce_libbitcoin()) ]]; then
.                   else
    if [[ $(test_produce_dependencies()) ]]; then
.                   endif
.                   build_github(_build, my.prefix)
    fi
.               else
    if [[ $(test_produce_project()) ]]; then
.                   build_github_test(_build, my.prefix)
    fi
.               endif
.           else
.               abort "Invalid build type: $(_build.name)."
.           endif
.       endif
.   endfor _build
}

.endmacro # define_build_local_copies
.
.macro define_invoke()
if [[ $DISPLAY_HELP ]]; then
    display_help
else
    display_configuration
    push_directory "$BUILD_SRC_DIR"
    initialize_git
    initialize_object_directory
    create_local_copies
    if [[ $SYNC_ONLY ]]; then
        display_message "Skipping build due to --sync-only."
    else
        time build_local_copies "${CONFIGURE_OPTIONS[@]}"
    fi
    pop_directory
fi
.endmacro # define_invoke
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_setup(path_prefix)
    for generate.repository by name as _repository
        require(_repository, "repository", "name")
        define my.output_path = join(my.path_prefix, _repository.name)
        define my.out_file = "$(my.output_path)/developer_setup.sh"
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
            define_help(_repository, _install, "developer_setup")

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
            define_set_prefix()
            define_set_pkgconfigdir(_config)
            define_set_with_boost_prefix(_config)
            define_display_configuration(_repository, _install)

            heading1("Define build functions.")
            define_build_functions(_install)

            heading1("The master download/clone/sync function.")
            define_create_local_copies(_install)

            heading1("The master build function.")
            define_build_local_copies(_install)

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

            close
        endnew _install
        endnew _config
    endfor _repository
endfunction # generate_setup
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

generate_setup("output")

.endtemplate
