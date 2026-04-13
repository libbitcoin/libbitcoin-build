@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions
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
set "PATH_INITIAL=!CD!"
pushd %~dp0
set "PATH_FILE=!CD!"
set "GSL_EXE=gsl -q"

REM Clean directories for generated build artifacts.
rmdir /s /q "output" 2>NUL

call :msg "Current directory: !CD!"
if not exist "!CD!\generate4.xml" (
    call :msg_error "Error: 'generate4.xml' not found in '!CD!'."
    exit /b 1
) else (
    call :msg_success "File 'generate4.xml' appears in '!CD!'."
)

call :msg_heading "Begin Execution context"
call :msg "PATH_INITIAL     : !PATH_INITIAL!"
call :msg "PATH_FILE        : !PATH_FILE!"
call :msg "GSL_EXE          : !GSL_EXE!"
call :msg "GITHUB_PATH      : !GITHUB_PATH!"
call :msg_heading "End Execution context"

!GSL_EXE! -q -script:"!CD!\gsl.copy_properties.cmd" "!CD!\generate4.xml"
if %ERRORLEVEL% neq 0 (
  call :msg_error "GSL execution failure."
  exit /b 1
)

!GSL_EXE! -q -script:"!CD!\gsl.generate_artifacts.cmd" "!CD!\generate4.xml"
if %ERRORLEVEL% neq 0 (
  call :msg_error "GSL execution failure."
  exit /b 1
)

if not exist "!CD!\copy_properties.cmd" (
  call :msg_error "Error: 'copy_properties.cmd' not found in '!CD!'."
  exit /b 1
)

call :msg "Execute copy_properties.cmd..."
call "!CD!\copy_properties.cmd"
if %ERRORLEVEL% neq 0 (
  call :msg_error "Failure calling 'copy_properties.cmd'."
  exit /b 1
)

if not exist "!CD!\generate_artifacts.cmd" (
  call :msg_error "Error: 'generate_artifacts.cmd' not found in '!CD!'."
  exit /b 1
)

call :msg "Execute generate_artifacts.cmd..."
call "!CD!\generate_artifacts.cmd"
if %ERRORLEVEL% neq 0 (
  call :msg_error "Failure calling 'generate_artifacts.cmd'."
  exit /b 1
)

if not exist "!CD!\generate.cmd" (
  call :msg_error "Error: 'generate.cmd' not found in '!CD!'."
  exit /b 1
)

if not exist "!CD!\version4.xml" (
  call :msg_error "Error: 'version4.xml' not found in '!CD!'."
  exit /b 1
)

call :msg "Execute generate.cmd..."
call "!CD!\generate.cmd" "!CD!\version4.xml" %*
if %ERRORLEVEL% neq 0 (
  call :msg_error "Failure calling 'generate.cmd'."
  exit /b 1
)

if not exist "!CD!\copy_projects.cmd" (
  call :msg_error "Error: 'copy_projects.cmd' not found in '!CD!'."
  exit /b 1
)

call :msg "Execute copy_projects.cmd..."
call "!CD!\copy_projects.cmd" %*
if %ERRORLEVEL% neq 0 (
  call :msg_error "Failure calling 'copy_projects.cmd'."
  exit /b 1
)

REM Restore directory.
popd
call :msg_success "Script execution completed successfully."

REM Delay for manual confirmation.
if not defined CI (
    pause
)

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
