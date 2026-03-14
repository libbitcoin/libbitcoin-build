@echo off
setlocal EnableDelayedExpansion

:: Assign arguments
set "source_dir=output"
set "dest_dir=.."

:: Check if source directory exists
if not exist "%source_dir%\" (
    echo Error: Source directory '%source_dir%' does not exist.
    exit /b 1
)

:: Check if destination directory exists
if not exist "%dest_dir%\" (
    echo Error: Destination directory '%dest_dir%' does not exits.
    exit /b 1
)

:: If no substring arguments are provided, copy all subdirectories
set copied=0
if "%~1"=="" (
    echo No substrings specified. Copying 'libbitcoin' subdirectories from '%source_dir%' to '%dest_dir%'...

    for /d %%i in ("%source_dir%\libbitcoin*") do (
        echo Copying '%%~nxi' to '%dest_dir%'...
        xcopy "%%i" "%dest_dir%\%%~nxi\" /E /I /Y
        set /a copied+=1
    )
) else (
    :: Copy subdirectories whose names contain any of the provided substrings
    for /d %%i in ("%source_dir%\*") do (
        for %%j in (%*) do (
            echo.%%~nxi | find /i "%%j" >nul
            if !errorlevel! equ 0 (
                echo Copying '%%~nxi' to '%dest_dir%'...
                xcopy "%%i" "%dest_dir%\%%~nxi\" /E /I /Y
                set /a copied+=1
            )
        )
    )
    if !copied! equ 0 (
        echo Warning: No subdirectories found in '%source_dir%' matching any provided substrings.
    )
)

echo Copy operation completed.
endlocal
