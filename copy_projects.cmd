@echo off
setlocal EnableDelayedExpansion

:: Assign arguments
set "source_dir=output"
set "dest_dir=.."

:: Check if source directory exists
if not exist "%source_dir%\" (
    echo Error: Source directory "%source_dir%" does not exist.
    exit /b 1
)

:: Create destination directory if it doesn't exist
if not exist "%dest_dir%\" (
    echo Error: Destination directory "%dest_dir%" does not exits.
    exit /b 1
)

:: If no substring arguments are provided, copy all subdirectories
if "%~1"=="" (
    echo No substrings specified. Copying all subdirectories from "%source_dir%" to "%dest_dir%"...
    for /d %%i in ("%source_dir%\*") do (
        set "subdir=%%~nxi"
        echo Copying '!subdir!' to '%dest_dir%'...
        xcopy "%%i" "%dest_dir%\!subdir!\" /E /I /Y
    )
) else (
    :: Copy subdirectories whose names contain any of the provided substrings
    set copied=0
    for /d %%i in ("%source_dir%\*") do (
        set "subdir=%%~nxi"
        set found=0
        for %%j in (%*) do (
            echo.!subdir! | find /i "%%j" >nul
            if !errorlevel! equ 0 (
                echo Copying '!subdir!' to '%dest_dir%'...
                xcopy "%%i" "%dest_dir%\!subdir!\" /E /I /Y
                set found=1
                set /a copied+=1
            )
        )
    )
    if !copied! equ 0 (
        echo Warning: No subdirectories found in "%source_dir%" matching any provided substrings.
    )
)

echo Copy operation completed.
endlocal
