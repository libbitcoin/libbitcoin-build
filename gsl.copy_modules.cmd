.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate copy_modules.cmd.
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

REM Do everything relative to this file location.
pushd %~dp0

.endmacro # emit_initialize
.
.macro emit_repository_initialize(repository, path_prefix)
.   define my.repository = emit_repository_initialize.repository
.   define my.dest_path = make_windows_path(\
        "$(my.path_prefix)/$(my.repository.name)/builds/cmake/modules/")
.
call :pending "Seeding modules for $(my.repository.name)"
if not exist "$(my.dest_path)" call mkdir "$(my.dest_path)"
.   emit_error_handler("Failed to create directory $(my.dest_path)")

.endmacro # emit_repository_initialize
.
.macro emit_module_copy(repository, dependency, path_prefix)
.   define my.repository = emit_module_copy.repository
.   define my.dependency = emit_module_copy.dependency
.   define my.src_path = make_windows_path(\
        "cmake/$(get_find_cmake_name(my.dependency))")
.   define my.dest_path = make_windows_path(\
        "$(my.path_prefix)/$(my.repository.name)/builds/cmake/modules/")
.
call xcopy /y "$(my.src_path)" "$(my.dest_path)"
.   emit_error_handler("Failed to copy $(my.src_path)")

.endmacro # emit_module_copy
.
.macro emit_repository_completion_message(repository_name)
call :success "Completed population of $(my.repository_name) artifacts."

.endmacro # emit_repository_completion_message
.
.macro emit_error_handler(message)
.   define my.message = emit_error_handler.message
if %ERRORLEVEL% NEQ 0 (
  call :failure "$(my.message)"
  call :cleanup
  exit /b 1
)
.endmacro # emit_error_handler
.
.macro emit_completion()
call :success "Successful duplication of modules to output directory."
exit /b 0

:cleanup
REM Restore directory.
popd

.endmacro # emit_completion
.
.macro emit_lib_colorized_echos()
:pending
echo [93m%~1[0m
exit /b 0

:success
echo [92m%~1[0m
exit /b 0

:failure
echo [91m%~1[0m
exit /b 0
.endmacro # emit_lib_colorized_echos
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_copy_modules(path_prefix)
    define out_file = "copy_modules.cmd"
    notify(out_file)
    output(out_file)
    batch_no_echo()
    bat_copyleft("libbitcoin-build")

    emit_initialize()

   for generate.repository by name as _repository
       echo(" Evaluating repository: $(_repository.name)")
        emit_repository_initialize(_repository, my.path_prefix)
        for _repository->configure.dependency as _dependency\
            where is_custom_module_find_dependency(_dependency)
            emit_module_copy(_repository, _dependency, my.path_prefix)
        endfor
        emit_repository_completion_message(_repository.name)
   endfor

    emit_completion()
    emit_lib_colorized_echos()
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
