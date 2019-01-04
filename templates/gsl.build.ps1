.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
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
    return defined(my.repository.name) & defined(my.build.repository) & (my.repository.name = my.build.repository)
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
    return !is_matching_repository_name(my.repository, my.build) & is_github_dependency(my.build) & !is_nugetable(my.build)
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_parameters()
param(
  [Parameter(Mandatory=$true)][string]\$PATH,
  [Parameter(Mandatory=$true)][string]\$PLATFORM,
  [Parameter(Mandatory=$true)][string]\$CONFIGURATION)

\$PATH_BASE = "\$PATH";
\$NUGET_PKG_PATH = "\$PATH_BASE\\..\\nuget";
\$MSBUILD_ARGS = "/verbosity:minimal /p:Platform=\$PLATFORM /p:Configuration=\$CONFIGURATION";
.endmacro # emit_parameters
.
.macro emit_instructions(repository)
.   define my.repository = emit_instructions.repository
\$(echo_pending "Build initialized...");
try {
  New-Item "\$NUGET_PKG_PATH" -type directory;
.   for my.repository->install.build as _build where is_build_dependency(my.repository, _build)
  \$(init_repository $(_build.github) $(_build.repository) $(_build.branch));
.   endfor
.
  \$(build_repository $(my.repository.name));
}
catch {
  \$Error = \$_;
  \$(echo_failure "Build failed.");
  Throw \$Error;
}
\$(echo_success "Build complete.");
.endmacro # emit_instructions
.
.macro emit_lib_init_repository()
function init_repository(\$account, \$repository, \$branch) {
  \$(echo_pending "Initializing repository $account/\$repository/\$branch...")
  try {
    \$(echo_pending "git clone -q --depth 3 --branch=\$branch https://github.com/\$account/\$repository \$PATH_BASE\\\$repository")
    \$(execute_cmd "git clone -q --depth 3 --branch=\$branch https://github.com/\$account/\$repository \$PATH_BASE\\\$repository")
    \$(build_repository_project \$repository)
  }
  catch {
    \$(echo_failure "Initialization of \$account/\$repository/\$branch failed.")
    Throw \$Error
  }
  \$(echo_success "Initialization of \$account/\$repository/\$branch succeeded.")
}
.endmacro # emit_lib_init_repository
.
.macro emit_lib_build_repository()
function build_repository(\$repository) {
  \$(echo_pending "Building respository \$repository...");
  \$(init_dependencies \$repository);
  try {
    \$(echo_pending "msbuild \$MSBUILD_ARGS \$repository.sln");
    \$(execute_cmd "cd /d \$PATH_BASE\\\$repository\\builds\\msvc\\vs2013 & msbuild \$MSBUILD_ARGS \$repository.sln")
  }
  catch {
    \$Error = \$_
    \$(echo_failure "Build repository $repository execution failed.")
    Throw \$Error
  }
  \$(echo_success "Build repository \$repository execution complete.")
}
.endmacro # emit_lib_build_repository
.
.macro emit_lib_build_repository_project()
function build_repository_project(\$repository) {
  \$(echo_pending "Building respository project \$repository...");
  \$(init_dependencies \$repository);
  try {
    \$(echo_pending "msbuild \$MSBUILD_ARGS /target:\$repository`:Rebuild \$repository.sln");
    \$(execute_cmd "cd /d \$PATH_BASE\\\$repository\\builds\\msvc\\vs2013 & msbuild \$MSBUILD_ARGS /target:\$repository`:Rebuild \$repository.sln")
  }
  catch {
    \$Error = \$_;
    \$(echo_failure "Build repository project \$repository execution failed.");
    Throw \$Error;
  }
  \$(echo_success "Build repository project \$repository execution complete.");
}
.endmacro # emit_lib_build_repository_project
.
.macro emit_lib_init_dependencies()
function init_dependencies($repository) {
  \$(echo_pending "nuget restoring dependencies for \$repository...");
  try {
    \$(echo_pending "nuget restore \$PATH_BASE\\\$repository\\builds\\msvc\\vs2013\\\$repository.sln -Outputdir \$NUGET_PKG_PATH");
    \$(execute_cmd "nuget restore \$PATH_BASE\\\$repository\\builds\\msvc\\vs2013\\\$repository.sln -Outputdir \$NUGET_PKG_PATH")
  }
  catch {
    \$Error = \$_
    \$(echo_failure "nuget restoration for \$repository failed.");
    Throw \$Error
  }
  \$(echo_success "nuget restoration for \$repository complete.");
}
.endmacro # emit_lib_init_dependencies
.
.macro emit_lib_colorized_echos()
function echo_failure(\$message) {
  Write-Host \$message -ForegroundColor Red;
}

function echo_pending(\$message) {
  Write-Host \$message -ForegroundColor Yellow;
}

function echo_success(\$message) {
  Write-Host \$message -ForegroundColor Green;
}
.endmacro # emit_lib_colorized_echos
.
.macro emit_lib_execute_cmd()
function execute_cmd(\$command) {
    \$result = Start-Process cmd.exe -ArgumentList "/c $command" -NoNewWindow -Wait -PassThru
    if (\$result.ExitCode -ne 0) { Throw \$result }
}
.endmacro # emit_lib_execute_cmd
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
.endtemplate
.template 1
.macro generate_build_ps1(path_prefix)
.for generate.repository by name as _repository
.   require(_repository, "repository", "name")
.   my.output_path = join(path_prefix, _repository.name)
.   create_directory(my.output_path)
.   define my.out_file = "$(my.output_path)/build.ps1"
.   notify(my.out_file)
.   output(my.out_file)
.   copyleft(_repository.name)

.   emit_parameters()

.   emit_lib_colorized_echos()

.   emit_lib_execute_cmd()

.   emit_lib_init_dependencies()

.   emit_lib_build_repository_project()

.   emit_lib_build_repository()

.   emit_lib_init_repository()

.   emit_instructions(_repository)
.
.   close
.endfor _repository
.endmacro # generate_build_ps1
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

generate_build_ps1("output")

.endtemplate
