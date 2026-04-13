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

set "GSL_EXE=gsl -q"

if "%~1"=="" (
    call :msg "Usage: %~nx0 configuration [targets...]"
    call :msg ""
    call :msg "  configuration        required xml file"
    call :msg "  targets              all targets to be copied"
    exit /b 1
)

set "CONFIG=%~1"
shift

set "TARGETS="
call :populate_targets %*

set "NAMES[1]=generate_artifacts"
set "NAMES[2]=copy_statics"
set "NAMES[3]=copy_projects"
set "NAMES.length=3"

for /L %%i in (1,1,%NAMES.length%) do (
    call :msg "!GSL_EXE! -q -script:'process\!NAMES[%%i]!.cmd.gsl' '!CONFIG!'"
    !GSL_EXE! -q -script:"process\!NAMES[%%i]!.cmd.gsl" "!CONFIG!"
    if %ERRORLEVEL% neq 0 (
        echo FAILURE: evaluating "process\!NAMES[%%i]!.cmd.gsl".
        exit /b %ERRORLEVEL%
    )
)

REM Execute process scripts (explicit enumeration).
pushd process
for /L %%i in (1,1,%NAMES.length%) do (
    call !NAMES[%%i]!.cmd !targets!
    if %ERRORLEVEL% neq 0 (
        exit /b %ERRORLEVEL%
    )
)
popd

echo "Generation for configuration %CONFIG% complete."
if not defined CI (
    pause
)

exit /b 0



:populate_targets
    shift
:begin
    if "%1"=="" goto done
    set "TARGETS=!TARGETS! %~1"
    shift
    goto begin
:done
    exit /b 0

:msg_heading
    call :msg "***************************************************************************"
    call :msg "%~1"
    call :msg "***************************************************************************"
    exit /b %ERRORLEVEL%

:msg
    if "%~1" == "" (
        echo.
    ) else (
        echo %~1
    )
    exit /b %ERRORLEVEL%

:msg_empty
    echo.
    exit /b %ERRORLEVEL%

:msg_verbose
    if "!DISPLAY_VERBOSE!" == "yes" (
        echo [96m%~1[0m
    )
    exit /b %ERRORLEVEL%

:msg_success
    echo [92m%~1[0m
    exit /b %ERRORLEVEL%

:msg_warn
    echo [93m%~1[0m
    exit /b %ERRORLEVEL%

:msg_error
    echo [91m%~1[0m
    exit /b %ERRORLEVEL%
