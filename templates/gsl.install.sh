.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
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
.macro define_main()
main()
{        
    initialize_the_build_environment "$@"
    build
}
.endmacro
.
.macro define_intialize_the_build_environemnt()

initialize_the_build_environment()
{
    enable_exit_on_first_error
    parse_command_line_options "$@"
    handle_help_line_option
    configure_build_parallelism
    define_operating_system_specific_settings
    link_to_standard_library_in_nondefault_scenarios
    write_configure_options "$@"
    handle_a_prefix
    display_configuration
    initialize_git
}
.endmacro 
.macro define_build(install)
.   define my.install = define_build.install

build()
{
    define_github_build_options

.   for my.install.build as _build
.       # Unique by build.name
.       if !defined(my.build_$(_build.name:c))
.           define my.build_$(_build.name:c) = 0
.
.           if (is_icu_build(_build))
.               define_build_icu_condition()
.           elsif (!is_github_build(_build))
.               define_nongithub_buildcall(_build)
.           elsif (is_github_build(_build))
.               formattedBuildName = string.replace(_build.name, "-|_")   
.               if (last())      
.                   define_last_build_call(_build)  
.               else 
.                   define_github_build_call(_build)    
.               endif
.           else
.               abort "Invalid build type: $(_build.name)."
.           endif
.       endif
.   endfor _build
}  
.endmacro # define_build_all
.
.macro define_build_icu_condition()
    if [[ $BUILD_ICU ]]; then
        build_from_tarball_icu
    else
        initialize_icu_packages
    fi
.endmacro #define_build_icu_condition
.
.macro define_nongithub_buildcall(build)
.   define build = define_nongithub_buildcall.build
    if [[ "$BUILD_$(build.name:upper)" ]]; then
        build_from_tarball_$(build.name)
    fi  
.endmacro #define_nongithub_builcall
.
.macro define_last_build_call(build)
.   define my.build = define_last_build_call.build
.   define formattedBuildName = string.replace(my.build.name, "-|_")   
    if [[ $TRAVIS == true ]]; then
        # Because Travis alread has downloaded the primary repo.
        build_from_local_with_tests "${$(formattedBuildName:upper)_OPTIONS[@]}"
    else
        build_from_github_with_tests $(my.build.github) $(my.build.repository) $(my.build.branch) "${$(formattedBuildName:upper)_OPTIONS[@]}"
    fi 
.endmacro #define_last_build_call
.
.macro define_github_build_call(build)
.   define my.build = define_github_build_call.build
.   define formattedBuildName = string.replace(my.build.name, "-|_")   
    build_from_github $(my.build.github) $(my.build.repository) $(my.build.branch) "${$(formattedBuildName:upper)_OPTIONS[@]}"
.endmacro #define_github_build_call
.
.macro define_handle_help_line_option()
handle_help_line_option()
{  
    if [[ $DISPLAY_HELP ]]; then     
        display_help      
        exit 0
    fi 
}

.endmacro # define_handle_help_line_option
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
.macro define_make_functions()
configure_and_make_and_install()
{
    local OPTIONS=("$@")
    local CONFIGURATION=("${OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}")    

    configure_options "${CONFIGURATION[@]}"
    make_jobs --silent
    make install   
    configure_links
}

autogen_and_configure_and_make_and_install()
{
    local OPTIONS=("$@")
    local CONFIGURATION=("${OPTIONS[@]}" "${CONFIGURE_OPTIONS[@]}")   

    ./autogen.sh
    configure_options "${CONFIGURATION[@]}"
    make_jobs
    make install
    configure_links
}

make_jobs()
{
    local JOBS="$PARALLEL"

    # Avoid setting -j1 (causes problems on Travis).
    local SEQUENTIAL=1
    if [[ $JOBS > $SEQUENTIAL ]]; then
        make -j"$JOBS" "$@"
    else
        make "$@"
    fi
}

.endmacro #define_make_functions
.
.macro define_utility_functions()
.   define_enable_exit_on_first_error()
.   define_disable_exit_on_first_error()
.   define_configure_links()
.   define_change_dir_for_build_and_download_and_extract()
.   define_make_functions()
.   define_configure_options()
.   define_make_tests()
.   define_create_directory()
.   define_push_pop_directory()
.endmacro # define_utility_functions
.
.macro define_builds_from_tarball(install)
.   define my.install = define_builds_from_tarball.install
.   if defined(my.install->build(name="icu"))
.        define_build_from_tarball_icu(my.install)
.   endif
.    
.   if defined(my.install->build(name="zlib"))
.        define_build_from_tarball_zlib(my.install)
.   endif
.
.   if defined(my.install->build(name="png"))
.       define_build_from_tarball_png(my.install)
.   endif
.   if defined(my.install->build(name="qrencode"))
.       define_build_from_tarball_qrencode(my.install)
.   endif
.
.   if defined(my.install->build(name="boost"))
.       define_build_from_tarball_boost(my.install)
.   endif
.
.   if defined(my.install->build(name="zmq"))
.       define_build_from_tarball_zmq(my.install)
.   endif
.
.   if defined(my.install->build(name="mbedtls"))
.       define_build_from_tarball_mbedlts(my.install)
.   endif
.endmacro #define_builds_from_taball
.
.macro define_build_from_tarball_icu(install)
.   define my.install = define_build_from_tarball_icu.install
build_from_tarball_icu()
{
.   icu_url = get_icu_url(my.install)
.   icu_file = get_icu_file(my.install)
    local URL="$(icu_url)"
    local ARCHIVE="$(icu_file)"
    local COMPRESSION="gzip"
.   define my.build = my.install->build(name="icu")
    local OPTIONS=(
.   for my.build.option as _option
    "$(_option.value)"$(last() ?? ")" ? " \\")
.   endfor _option

    local SAVE_LDFLAGS=$LDFLAGS
    export LDFLAGS="-L$PREFIX/lib $LDFLAGS"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    push_directory "source"
    configure_and_make_and_install "${OPTIONS[@]}"

    pop_directory
    pop_directory
    pop_directory

    # Restore flags to prevent side effects.
    export LDFLAGS=$SAVE_LDFLAGS
}

.   define_initialize_icu_packages()
.endmacro #build_from_tarball_icu
.
.macro define_build_from_tarball_zlib(install)
.   define my.install =  define_build_from_tarball_zlib.install
build_from_tarball_zlib()
{
.   zlib_url = get_zlib_url(my.install)
.   zlib_file = get_zlib_file(my.install)
    local URL="$(zlib_url)"
    local ARCHIVE="$(zlib_file)"
    local COMPRESSION="gzip"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    
    # Enable static only zlib build.
    patch_zlib_configuration  
    configure_and_make_and_install  

    clean_zlib_build

    pop_directory
    pop_directory
}

.   define_patch_zlib_configuration()
.   define_clean_zlib_build()
.endmacro #define_build_from_tarball_zlib
.
.macro define_build_from_tarball_png(install)
.   define my.install = define_build_from_tarball_png.install
build_from_tarball_png()
{
.   png_url = get_png_url(my.install)
.   png_file = get_png_file(my.install)
    local URL="$(png_url)"
    local ARCHIVE="$(png_file)"
    local COMPRESSION="xz"

    # Because libpng doesn't actually use pkg-config to locate zlib.
    local SAVE_LDFLAGS=$LDFLAGS
    export LDFLAGS="-L$PREFIX/lib $LDFLAGS"    

    # Because libpng doesn't actually use pkg-config to locate zlib.h. 
    local SAVE_CPPFLAGS=$CPPFLAGS
    export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    configure_and_make_and_install   

    pop_directory
    pop_directory

    # Restore flags to prevent side effects.
    export LDFLAGS=$SAVE_LDFLAGS
    export CPPFLAGS=$SAVE_CPPFLAGS
}

.endmacro #define_build_from_tarball_png
.
.macro define_build_from_tarball_qrencode(install)
.   define my.install = define_build_from_tarball_qrencode.install
build_from_tarball_qrencode()
{
.   qrencode_url = get_qrencode_url(my.install)
.   qrencode_file = get_qrencode_file(my.install)
    local URL="$(qrencode_url)"
    local ARCHIVE="$(qrencode_file)"
    local COMPRESSION="bzip2"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    configure_and_make_and_install   

    pop_directory
    pop_directory
}

.endmacro #define_build_from_tarball_qrencode
.
.macro define_build_from_tarball_boost(install)
.   define my.install = define_build_from_tarball_boost.install
# Because boost doesn't use autoconfig.
build_from_tarball_boost()
{
.   boost_url = get_boost_url(my.install)
.   boost_file = get_boost_file(my.install)
    local URL="$(boost_url)"
    local ARCHIVE="$(boost_file)"
    local COMPRESSION="bzip2"  
.   define my.build = my.install->build(name="boost")
    local OPTIONS=(
.   for my.build.option as _option
    "$(_option.value)"$(last() ?? ")" ? " \\")
.   endfor _option

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"  
    initialize_boost_configuration
    initialize_boost_icu_configuration
    display_boost_configuration "${OPTIONS[@]}"  

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
        "-j $PARALLEL" \\
        "-d0" \\
        "-q" \\
        "--reconfigure" \\
        "--prefix=$PREFIX" \\
        "${OPTIONS[@]}"

    pop_directory
    pop_directory
}

.   define_boost_build_configuration_helpers()
.endmacro #define_build_from_tarball_boost
.
.macro define_build_from_tarball_zmq(install)
.   define my.install = define_build_from_tarball_zmq.install
build_from_tarball_zmq()
{
.   zmq_url = get_zmq_url(my.install)
.   zmq_file = get_zmq_file(my.install)
    local URL="$(zmq_url)"
    local ARCHIVE="$(zmq_file)"
    local COMPRESSION="gzip"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    configure_and_make_and_install   

    pop_directory
    pop_directory
}

.endmacro #define_build_from_tarball_zmq
.
.macro define_build_from_tarball_mbedlts(install)
.   define my.install = define_build_from_tarball_mbedlts.install
build_from_tarball_mbedlts()
{
.   mbedtls_url = get_mbedtls_url(my.install)
.   mbedtls_file = get_mbedtls_file(my.install)
    local URL="$(mbedtls_url)"
    local ARCHIVE="$(mbedtls_file)"
    local COMPRESSION="gzip"    

    change_dir_for_build_and_download_and_extract "$ARCHIVE" "$URL" "$COMPRESSION"   
    make_jobs lib
    make DESTDIR=$PREFIX install

    pop_directory
    pop_directory
}

.endmacro #define_build_from_tarball_mbedlts
.
.macro define_github_build_functions()
# Standard build from github.
build_from_github()
{  
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3
    shift 3
    local OPTIONS=("$@")

    FORK="$ACCOUNT/$REPO"
    push_directory "$BUILD_DIR"
    display_heading_message "Download $FORK/$BRANCH"

    # Clone the repository locally.
    git clone --depth 1 --branch "$BRANCH" --single-branch "https://github.com/$FORK"   

    # Build the local repository clone.
    push_directory "$REPO"
    autogen_and_configure_and_make_and_install "${OPTIONS[@]}"
    pop_directory
    pop_directory
}

build_from_local_with_tests()
{
    local OPTIONS=("$@")
    build_from_local "Local $TRAVIS_REPO_SLUG" "${OPTIONS[@]}"
    make_tests
}

# Standard build of current directory.
build_from_local()
{
    local MESSAGE="$1"    
    shift 1
    local OPTIONS=("$@")

    display_heading_message "$MESSAGE"

    # Build the current directory.
    autogen_and_configure_and_make_and_install "${OPTIONS[@]}"
}

build_from_github_with_tests()
{
    local ACCOUNT=$1
    local REPO=$2
    local BRANCH=$3  
    shift 3
    local OPTIONS=("$@")

    build_from_github "$ACCOUNT" "$REPO" "$BRANCH" "${OPTIONS[@]}"
    push_directory "$BUILD_DIR"
    push_directory "$REPO"
    make_tests
    pop_directory
    pop_directory
}

.endmacro #define_github_build_functions
.
.macro define_display_functions(repository, install, script_name)
.   define my.repository = define_display_functions.repository
.   define my.install = define_display_functions.install
.   define my.script_name = define_display_functions.script_name
.   define_print_functions()
.   define_display_configuration(my.repository, my.install)
.   define_help(my.repository, my.install, my.script_name) 
.   define_display_boost_configuration()
.endmacro #define_display_functions
.
.macro define_start_script()
main "$@"
.endmacro #define_start_script
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
    define my.install = _repository->install
    create_directory(my.output_path)
    notify(my.out_file)
    output(my.out_file)

    shebang("bash")

    copyleft(_repository.name)
    documentation(_repository, my.install)

    heading1("Define constants.")
    define_build_directory(_repository)    

    define_main()
    define_intialize_the_build_environemnt()
    define_build(my.install)    

    heading1("Initialize the build environment.")
    define_parse_command_line_options(_repository, my.install)
    define_handle_help_line_option()
    define_configure_build_parallelism()
    define_operating_system_specific_settings()
    define_link_to_standard_library_in_nondefault_scenarios()
    define_write_configure_options()
    define_handle_a_prefix()
    define_initialize_git()

    heading1("Define github build options.")
    define_build_options(my.install)        

    heading1("Define build functions.")
    define_builds_from_tarball(my.install)
    define_github_build_functions()

    heading1("Define utility functions.")
    define_utility_functions()

    heading1("Define display functions.")
    define_display_functions(_repository, my.install, "install")
    
    define_start_script()

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
