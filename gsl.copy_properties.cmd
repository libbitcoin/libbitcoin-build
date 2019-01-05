.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate copy_properties.cmd.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_initialize()

REM Do everything relative to this file location.
pushd %~dp0

.endmacro emit_initialize
.
.macro emit_import_copy_project(repository, output, import_name, vs_version)
.   define my.repository = emit_import_copy_project.repository
.   define my.msvc_path = "$(my.output)\\$(canonical_path_name(my.repository))\\builds\\msvc\\$(my.vs_version)"
if not exist "$(my.msvc_path)" call mkdir "$(my.msvc_path)"
.   emit_error_handler("Failed to create directory.")

call :pending "Seeding imports $(my.msvc_path)"
call xcopy /y "props\\import\\$(my.import_name).import.*" $(my.msvc_path)
.   emit_error_handler("Failed to copy import files.")

.endmacro emit_import_copy_project
.
.macro emit_import_copy(repository, output, import_name)
.   define my.repository = emit_import_copy.repository
REM Copy $(my.import_name) imports for $(my.repository.name)
.   emit_import_copy_project(my.repository, my.output, my.import_name, "vs2013")
.   emit_import_copy_project(my.repository, my.output, my.import_name, "vs2015")
.   emit_import_copy_project(my.repository, my.output, my.import_name, "vs2017")
.   define my.msvc_path = "$(my.output)\\$(canonical_path_name(my.repository))\\builds\\msvc"
if not exist "$(my.msvc_path)\\build\\" call mkdir "$(my.msvc_path)\\build\\"
.   emit_error_handler("Failed to create build directory.")
call xcopy /y "props\\nuget.config" "$(my.msvc_path)"
.   emit_error_handler("Failed to copy nuget.config.")

call xcopy /y "props\\build\\build_base.bat" "$(my.msvc_path)\\build\\"
.   emit_error_handler("Failed to copy build_base.bat.")

.endmacro
.
.macro emit_project_props_copy_project(repository, output, vs_version)
.   define my.repository = emit_project_props_copy_project.repository
.   define my.msvc_path = "$(my.output)\\$(canonical_path_name(my.repository))\\builds\\msvc\\$(my.vs_version)"
call :pending "Seeding props $(my.msvc_path)"
call xcopy /s /y "props\\project\\$(my.repository.name)\\*" $(my.msvc_path)
.   emit_error_handler("Failed to copy import files.")

.endmacro
.
.macro emit_project_props_copy(repository, output)
.   define my.repository = emit_project_props_copy.repository
REM Copy project props for $(my.repository.name)
.   emit_project_props_copy_project(my.repository, my.output, "vs2013")
.   emit_project_props_copy_project(my.repository, my.output, "vs2015")
.   emit_project_props_copy_project(my.repository, my.output, "vs2017")
.endmacro
.
.macro emit_repository_completion_message(repository)
.   my.repository = emit_repository_completion_message
call :success "Completed population of $(my.repository.name) artifacts."
.endmacro emit_repository_completion_message
.
.macro emit_error_handler(message)
.   define my.message = emit_error_handler.message
if %ERRORLEVEL% NEQ 0 (
  call :failure "$(my.message)"
  call :cleanup
  exit /b 1
)
.endmacro emit_error_handler
.
.macro emit_completion()
call :success "Successful duplication of imports/props to output directory."
exit /b 0

:cleanup
REM Restore directory.
popd

.endmacro emit_completion
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
.endmacro emit_lib_colorized_echos
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_artifacts(path_prefix)
    define out_file = "copy_properties.cmd"
    notify(out_file)
    output(out_file)
    batch_no_echo()
    bat_copyleft("libbitcoin-build")

    emit_initialize()

# TODO: walk dependency tree, not build list.
# TODO: build list is for telling installer what to compile.
    for generate.repository by name as _repository
        for _repository->install.build as _build where\
            defined(_build.repository) &\
            starts_with(_build.repository, "libbitcoin")
            emit_import_copy(_repository, my.path_prefix, _build.repository)
        endfor
        emit_project_props_copy(_repository, my.path_prefix)
        emit_repository_completion_message(_repository)
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

generate_artifacts("output")

.endtemplate
