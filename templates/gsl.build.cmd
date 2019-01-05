.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate libbitcoin build.cmd.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################
function is_matching_repository_name(repository, build)
    define my.repository = is_matching_repository_name.repository
    define my.build = is_matching_repository_name.build
    return defined(my.repository.name) & defined(my.build.repository) & \
        (my.repository.name = my.build.repository)
endfunction

function is_github_dependency(build)
    define my.build = is_github_dependency.build
    return defined(my.build.github)
endfunction

function is_nugetable(build)
    define my.build = is_nugetable.build
    return defined(my.build.nuget) & (my.build.nuget = "true")
endfunction

function is_build_dependency(repository, build)
    define my.repository = is_build_dependency.repository
    define my.build = is_build_dependency.build
    return !is_matching_repository_name(my.repository, my.build) & \
        is_github_dependency(my.build) & !is_nugetable(my.build)
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_error_handler(message)
.   define my.message = emit_error_handler.message
IF %ERRORLEVEL% NEQ 0 (
  call :failure "$(my.message)"
  exit /b 1
)
.endmacro # emit_error_handler
.
.macro emit_error_handler_indent(message)
.   define my.message = emit_error_handler_indent.message
  IF %ERRORLEVEL% NEQ 0 (
    call :failure "$(my.message)"
    exit /b 1
  )
.endmacro # emit_error_handler_indent
.
.macro emit_instructions(repository)
.   define my.repository = emit_instructions.repository
call :pending "Build initialized..."
IF NOT EXIST "%nuget_pkg_path%" (
  call mkdir "%nuget_pkg_path%"
.   emit_error_handler_indent("mkdir %nuget_pkg_path% failed.")
)

.   for my.repository->install.build as _build where is_build_dependency(my.repository, _build)
.#call :$(_build.repository)
.#  emit_error_handler("Build failed.")
call :init $(_build.github) $(_build.repository) $(_build.branch)
.       emit_error_handler("Initializing repository $(_build.github) $(_build.repository) $(_build.branch) failed.")
.   endfor
.
call :bld_repo $(my.repository.name)
.   emit_error_handler("Building $(my.repository.name) failed.")

call :success "Build complete."
exit /b 0
.endmacro # emit_instructions
.
.macro emit_lib_init_repository()
:init
call :pending "Initializing repository %~1/%~2/%~3..."
IF NOT EXIST "%path_base%\\%~2" (
  call git clone -q --branch=%~3 https://github.com/%~1/%~2 "%path_base%\\%~2"
.   emit_error_handler_indent("git clone %~1/%~2 failed.")
) ELSE (
  call :success "%path_base%\\%~2 exists, assuming valid clone."
)

call :bld_proj %~2
.   emit_error_handler("Building project %~2 failed.")
call :success "Initialization of %~1/%~2/%~3 complete."
exit /b 0
.endmacro # emit_lib_init_repository
.
.macro emit_lib_build_repository()
:bld_repo
call :pending "Building respository %~1..."
call :depends "%~1"
.   emit_error_handler("Initializing dependencies %~1 failed.")
call cd /d "%path_base%\\%~1\\builds\\msvc\\%proj_version%"
call "%msbuild_exe%" %msbuild_args% %~1.sln
.   emit_error_handler("%msbuild_exe% %msbuild_args% %~1.sln failed.")
call :success "Building repository %~1 execution complete."
call cd /d "%path_base%"
exit /b 0
.endmacro # emit_lib_build_repository
.
.macro emit_lib_build_repository_project()
:bld_proj
call :pending "Building respository project %~1..."
call :depends %~1
.   emit_error_handler("Initializing dependencies %~1 failed.")
call cd /d "%path_base%\\%~1\\builds\\msvc\\%proj_version%"
call "%msbuild_exe%" %msbuild_args% /target:%~1:Rebuild %~1.sln
.   emit_error_handler("%msbuild_exe% %msbuild_args% /target:%~1:Rebuild %~1.sln")
call :success "Building repository project %~1 execution complete."
call cd /d "%path_base%"
exit /b 0
.endmacro # emit_lib_build_repository_project
.
.macro emit_lib_init_dependencies()
:depends
call :pending "nuget restoring dependencies for %~1..."
call nuget restore "%path_base%\\%~1\\builds\\msvc\\%proj_version%\\%~1.sln" -Outputdir "%nuget_pkg_path%"
.   emit_error_handler("nuget restore failed.")
call :success "nuget restoration for %~1 complete."
exit /b 0
.endmacro # emit_lib_init_dependencies
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
.macro initialize_batch_script
@echo off
SETLOCAL ENABLEEXTENSIONS
SET "parent=%~dp0"
SET "path_base=%~1"
SET "nuget_pkg_path=%~1\\.nuget\\packages"
SET "msbuild_args=/verbosity:minimal /p:Platform=%~2 /p:Configuration=%~3"
SET "proj_version=%~4"
SET "msbuild_exe=msbuild"
IF EXIST "%~5" SET "msbuild_exe=%~5"
.endmacro #initialize_batch_script
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
.endtemplate
.template 1
.macro generate_build_cmd(path_prefix)
.for generate.repository by name as _repository
.   require(_repository, "repository", "name")
.   my.output_path = join(my.path_prefix, canonical_path_name(_repository))
.   create_directory(my.output_path)
.   define my.out_file = "$(my.output_path)/build.cmd"
.   notify(my.out_file)
.   output(my.out_file)
.   bat_copyleft(_repository.name)
.   initialize_batch_script()

.   emit_instructions(_repository)



.   emit_lib_init_repository()

.   emit_lib_build_repository()

.   emit_lib_build_repository_project()

.   emit_lib_init_dependencies()

.   emit_lib_colorized_echos()
.
.   close
.endfor _repository
.endmacro # generate_build_cmd
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

generate_build_cmd("output")

.endtemplate
