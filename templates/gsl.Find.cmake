.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate Find<pkg-config dependency>.cmake.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

###
### string generators
###
function project_relative_build_path()
    return "builds/cmake/modules"
endfunction

function emit_repository_find_cmake_files(repository, configure, output_path)
    define my.repository = emit_repository_find_cmake_files.repository
    define my.configure = emit_repository_find_cmake_files.configure

    for my.configure.dependency as _dependency \
        where is_package_dependency(_dependency)

        define my.out_file = "$(my.output_path)/Find$(_dependency.name:neat).cmake"
        notify(my.out_file)
        output(my.out_file)
        copyleft(_repository.name)
        emit_documentation(_repository, _dependency)
        emit_find_logic(_repository, _dependency)
        close
    endfor _dependency

endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_documentation(repository, dependency)
.   define my.repository = emit_documentation.repository
.   define my.dependency = emit_documentation.dependency
.
# Find$(my.dependency.name:neat)
#
# Use this module by invoking find_package with the form::
#
#   find_package( $(my.dependency.name:neat)
#     [version]              # Minimum version
#     [REQUIRED]             # Fail with error if $(my.dependency.name) is not found
#   )
#
#   Defines the following for use:
#
#   $(my.dependency.name:c)_FOUND         - true if headers and requested libraries were found
#   $(my.dependency.name:c)_INCLUDE_DIRS  - include directories for $(my.dependency.name) libraries
#   $(my.dependency.name:c)_LIBRARY_DIRS  - link directories for $(my.dependency.name) libraries
#   $(my.dependency.name:c)_LIBRARIES     - $(my.dependency.name) libraries to be linked
#   $(my.dependency.name:c)_PKG           - $(my.dependency.name) pkg-config package specification.
#

.endmacro # emit_documentation
.
.macro emit_find_logic(repository, dependency)
.   define my.repository = emit_find_logic.repository
.   define my.dependency = emit_find_logic.dependency
.   define my.prefix = is_true(my.dependency.unprefixed) ?? "" ? "lib"
.
if (MSVC)
    if ( $(my.dependency.name:neat)_FIND_REQUIRED )
        set( _$(my.dependency.name:c)_MSG_STATUS "SEND_ERROR" )
    else ()
        set( _$(my.dependency.name:c)_MSG_STATUS "STATUS" )
    endif()

    set( $(my.dependency.name:c)_FOUND false )
    message( ${_$(my.dependency.name:c)_MSG_STATUS} "MSVC environment detection for '$(my.dependency.name)' not currently supported." )
else ()
    # required
    if ( $(my.dependency.name:neat)_FIND_REQUIRED )
        set( _$(my.dependency.name:c)_REQUIRED "REQUIRED" )
    endif()

    # quiet
    if ( $(my.dependency.name:neat)_FIND_QUIETLY )
        set( _$(my.dependency.name:c)_QUIET "QUIET" )
    endif()

    # modulespec
    if ( $(my.dependency.name:neat)_FIND_VERSION_COUNT EQUAL 0 )
        set( _$(my.dependency.name:c)_MODULE_SPEC "$(my.prefix)$(my.dependency.name)" )
    else ()
        if ( $(my.dependency.name:neat)_FIND_VERSION_EXACT )
            set( _$(my.dependency.name:c)_MODULE_SPEC_OP "=" )
        else ()
            set( _$(my.dependency.name:c)_MODULE_SPEC_OP ">=" )
        endif()

        set( _$(my.dependency.name:c)_MODULE_SPEC "$(my.prefix)$(my.dependency.name) ${_$(my.dependency.name:c)_MODULE_SPEC_OP} ${$(my.dependency.name:neat)_FIND_VERSION}" )
    endif()

    pkg_check_modules( $(my.dependency.name:c) ${_$(my.dependency.name:c)_REQUIRED} ${_$(my.dependency.name:c)_QUIET} "${_$(my.dependency.name:c)_MODULE_SPEC}" )
    set( $(my.dependency.name:c)_PKG "${_$(my.dependency.name:c)_MODULE_SPEC}" )
endif()
.endmacro # emit_find_logic
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_find_cmake(path_prefix, repository_fan_out)
for generate.repository by name as _repository
    require(_repository, "repository", "name")
    define my.output_path = !is_true(my.repository_fan_out) ??\
        my.path_prefix ?\
        append_path(append_path(my.path_prefix, _repository.name),\
            project_relative_build_path())

    create_directory(my.output_path)
    emit_repository_find_cmake_files(_repository, _repository->configure,\
        my.output_path)

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

generate_find_cmake("cmake", "false")

.endtemplate
