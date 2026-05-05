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

:: Assign arguments
set "SOURCE_DIR=output"
set "DEST_DIR=.."

:: Check if source directory exists
if not exist "%SOURCE_DIR%" (
    call :msg_error "Error: Source directory '%SOURCE_DIR%' does not exist."
    exit /b 1
)

:: Check if destination directory exists
if not exist "%DEST_DIR%" (
    call :msg_error "Error: Destination directory '%DEST_DIR%' does not exist."
    exit /b 1
)

:: If no substring arguments are provided, copy all subdriectories
set "COPIED=0"

if "%~1"=="" (
    call :msg_warn "No substrings specified. Copying all 'libbitcoin' subdirectories from '%SOURCE_DIR%' to '%DEST_DIR%'..."

    for /d %%i in ("%SOURCE_DIR%\libbitcoin*") do (
		call :copy_repository "%%i" "%%~nxi"
     	if not !ERRORLEVEL! equ 0 (
			exit /b 1
		)
		set /a COPIED+=1
    )
) else (
    :: Copy subdirectories whose names contain any of the provided substrings
    for /d %%i in ("%SOURCE_DIR%\libbitcoin*") do (
		set "dirpath=%%i"
		set "dirname=%%~nxi"
		call :msg_warn "Evaluating !dirname!..."
		set "MATCHED=0"
        for %%j in (%*) do (
			call :msg_warn "Value %%j"
            echo.!dirname! | find /i "%%j" >nul
            if !ERRORLEVEL! equ 0 (
				set "MATCHED=1"
            )
        )

		if !MATCHED! equ 1 (
			call :msg_warn "Copying '!dirname!'..."
			call :copy_repository "!dirpath!" "!dirname!"
			if not !ERRORLEVEL! equ 0 (
				call :msg_error "Error triggered exit."
				exit /b 1
			)
			set /a COPIED+=1
		) else (
			call :msg_warn "  No match for '%%~nxi'"
		)
    )
)

if !COPIED! equ 0 (
	call :msg_warn "Warning: No subdirectories found in '%SOURCE_DIR%' matching any provided substrings."
) else (
	call :msg_success "Copied !COPIED! repositories."
)

popd
call :msg_success "Copy operation completed successfully."
exit /b 0


:copy_repository
	call :msg "Copying '%~2' to '%DEST_DIR%'..."
	xcopy "%~1" "%DEST_DIR%\%~2" /E /I /Y
	if not !ERRORLEVEL! equ 0 (
		call :msg_error "  Copy failed for '%~2'"
		exit /b 1
	)
	exit /b 0


:msg_heading
    call :msg "***************************************************************************"
    call :msg "%~1"
    call :msg "***************************************************************************"
    exit /b !ERRORLEVEL!

:msg
    if "%~1" == "" (
        echo.
    ) else (
        echo %~1
    )
    exit /b !ERRORLEVEL!

:msg_empty
    echo.
    exit /b !ERRORLEVEL!

:msg_verbose
    if "!DISPLAY_VERBOSE!" == "yes" (
        echo [96m%~1[0m
    )
    exit /b !ERRORLEVEL!

:msg_success
    echo [92m%~1[0m
    exit /b !ERRORLEVEL!

:msg_warn
    echo [93m%~1[0m
    exit /b !ERRORLEVEL!

:msg_error
    echo [91m%~1[0m
    exit /b !ERRORLEVEL!
