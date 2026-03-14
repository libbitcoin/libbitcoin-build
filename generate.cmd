@echo off
setlocal EnableDelayedExpansion

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

set "configuration=%~1"
shift

set "targets="
call :populate_targets %*

set "names[1]=generate_artifacts"
set "names[2]=copy_statics"
set "names[3]=copy_projects"
set "names.length=3"

for /L %%i in (1,1,%names.length%) do (
    echo gsl -q -script:"process\!names[%%i]!.cmd.gsl" "!configuration!"
    gsl -q -script:"process\!names[%%i]!.cmd.gsl" "!configuration!"
    if %errorlevel% neq 0 (
        echo FAILURE: evaluating "process\!names[%%i]!.cmd.gsl".
        exit /b %errorlevel%
    )
)

REM Execute process scripts (explicit enumeration).
pushd process
for /L %%i in (1,1,%names.length%) do (
    call !names[%%i]!.cmd !targets!
    if %errorlevel% neq 0 (
        pause
        exit /b %errorlevel%
    )
)
popd

echo "Generation for configuration %CONFIGURATION% complete."
pause
exit /b 0

:populate_targets
    shift
    :begin
    if "%1"=="" goto done
    set "targets=%targets% %~1"
    shift
    goto begin
    :done
    exit /b 0
