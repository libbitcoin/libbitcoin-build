.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate version.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
[global].root = ".."
[global].trace = 0
[gsl].ignorecase = 0

gsl from "utilities.gsl"

.endtemplate
.template 1
.macro generate_artifact()
.   define out_file = "update_repository_artifacts.cmd"
.   notify(out_file)
.   output(out_file)
.   batch_no_echo()
.   bat_copyleft("libbitcoin-build")

REM Do everything relative to this file location.
pushd %~dp0

REM Clean directories for generated build artifacts.
rmdir /s /q "output" 2>NUL

REM Generate build artifacts.
.   for buildgen->templates.template as _template
gsl -q -script:templates\\$(_template.name) generate.xml
if %errorlevel% neq 0 goto error

.   endfor

REM Copy outputs to all repositories.
.   for buildgen->repositories.repository by name as _repo
xcopy /s /y output\\$(_repo.name)\\* ..\\$(_repo.name)\\
.   endfor

REM Generate bindings from generated binding generators.
REM The path to swig.exe must be in our path.
.   for buildgen->repositories.repository by name as _repo
REM call ..\\$(_repo.name)\\bindings.bat
.   endfor

echo --- OKAY, generation completed.
goto end

:error
echo *** ERROR, generation terminated early.

:end
REM Restore directory.
popd

REM Delay for manual confirmation.
pause

.endmacro generate_artifact
.endtemplate
.template 0

generate_artifact()

.endtemplate
