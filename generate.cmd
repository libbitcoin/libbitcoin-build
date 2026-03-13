@echo off
REM ###########################################################################
REM  Copyright (c) 2014-2026 libbitcoin developers (see COPYING).
REM
REM  Generate libbitcoin-build artifacts from XML + GSL.
REM
REM  This executes the iMatix GSL code generator.
REM  See https://github.com/imatix/gsl for details.
REM
REM  Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM  Extract gsl.exe from package using NuGet's File > Export
REM ###########################################################################

REM Do everything relative to this file location.
pushd %~dp0

if "%~1"=="" (
    echo Usage: %~nx0 configuration [targets...]
    echo.
    echo   configuration        required xml file
    echo   targets              all targets to be copied
    exit /b 1
)

set "CONFIGURATION=%~1"
shift

REM Generate process scripts (explicit enumeration).
gsl -q -script:process/generate_artifacts.cmd.gsl "%CONFIGURATION%"
gsl -q -script:process/copy_statics.cmd.gsl "%CONFIGURATION%"
gsl -q -script:process/copy_projects.sh.gsl "%CONFIGURATION%"

REM Execute process scripts (explicit enumeration).
call process\generate_artifacts.cmd
pushd process
call copy_statics.cmd %*
call copy_projects.cmd %*
popd
echo "Generation for configuration %CONFIGURATION% complete."

REM Delay for manual confirmation.
call pause
