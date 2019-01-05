.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate generate_artifacts.cmd.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Generation
###############################################################################
.endtemplate
.template 1
.macro generate_artifact()
.   define out_file = "generate_artifacts.cmd"
.   notify(out_file)
.   output(out_file)
.   batch_no_echo()
.   bat_copyleft("libbitcoin-build")

REM Do everything relative to this file location.
pushd %~dp0

REM Generate build artifacts.
.   for generate->templates.template as _template
gsl -q -script:templates\\$(_template.name) generate.xml
if %errorlevel% neq 0 goto error

.   endfor

echo --- OKAY, generation completed.
goto end

:error
echo *** ERROR, generation terminated early.

:end
REM Restore directory.
popd

.endmacro generate_artifact
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

generate_artifact()

.endtemplate
