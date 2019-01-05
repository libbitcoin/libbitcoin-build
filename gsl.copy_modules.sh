.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate copy_modules.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Function
###############################################################################

function is_custom_module_find_dependency(dependency)
    define my.dependency = is_custom_module_find_dependency.dependency

    return !(is_boost_dependency(my.dependency)\
        | is_boost_lib_dependency(my.dependency)\
        | is_java_dependency(my.dependency)\
        | is_python_dependency(my.dependency)\
        | is_pthread_dependency(my.dependency)\
        | is_iconv_dependency(my.dependency))\
        | is_package_dependency(my.dependency)
endfunction

function get_find_cmake_name(dependency)
    define my.dependency = get_find_cmake_name.dependency
    return "Find$(my.dependency.name:neat).cmake"
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_initialize()

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
cd `dirname "$0"`

.endmacro
.
.macro emit_repository_initialize(repository, path_prefix)
.   define my.repository = emit_repository_initialize.repository
.

    mkdir -p $(my.path_prefix)/$(my.repository.name)/builds/cmake/modules/
.
.endmacro
.
.macro emit_module_copy(repository, dependency, path_prefix)
.   define my.repository = emit_module_copy.repository
.   define my.dependency = emit_module_copy.dependency
.
    eval cp -f cmake/$(get_find_cmake_name(my.dependency)) $(my.path_prefix)/$(my.repository.name)/builds/cmake/modules/
.endmacro
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_copy_modules(path_prefix)
    define out_file = "copy_modules.sh"
    notify(out_file)
    output(out_file)
    shebang("bash")
    copyleft("libbitcoin-build")

    emit_initialize()

   for generate.repository by name as _repository
       echo(" Evaluating repository: $(_repository.name)")
        emit_repository_initialize(_repository, my.path_prefix)
        for _repository->configure.dependency as _dependency\
            where is_custom_module_find_dependency(_dependency)
            emit_module_copy(_repository, _dependency, my.path_prefix)
       endfor
   endfor

endfunction
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

generate_copy_modules("output")

.endtemplate
