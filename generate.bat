@echo off
REM ###########################################################################
REM  Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
REM 
REM  Generate libbitcoin build artifacts from XML + GSL.
REM 
REM  This executes the iMatix GSL code generator.
REM  See https://github.com/imatix/gsl for details.
REM
REM  Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM  Extract gsl.exe from package using NuGet's File > Export
REM ###########################################################################

REM Do everything relative to this file location.
pushd %~dp0

REM Clean directories for generated build artifacts.
rmdir /s /q libbitcoin            2>NUL
rmdir /s /q libbitcoin-blockchain 2>NUL
rmdir /s /q libbitcoin-client     2>NUL
rmdir /s /q libbitcoin-consensus  2>NUL
rmdir /s /q libbitcoin-database   2>NUL
rmdir /s /q libbitcoin-explorer   2>NUL
rmdir /s /q libbitcoin-network    2>NUL
rmdir /s /q libbitcoin-node       2>NUL
rmdir /s /q libbitcoin-protocol   2>NUL
rmdir /s /q libbitcoin-server     2>NUL

REM Generate build artifacts.
gsl -q generate.xml

REM Handle errors below.
if %errorlevel% neq 0 goto error

REM Copy outputs to all repositories.
xcopy /s /y libbitcoin\*             ..\libbitcoin\
xcopy /s /y libbitcoin-blockchain\*  ..\libbitcoin-blockchain\
xcopy /s /y libbitcoin-client\*      ..\libbitcoin-client\
xcopy /s /y libbitcoin-consensus\*   ..\libbitcoin-consensus\
xcopy /s /y libbitcoin-database\*    ..\libbitcoin-database\
xcopy /s /y libbitcoin-explorer\*    ..\libbitcoin-explorer\
xcopy /s /y libbitcoin-network\*     ..\libbitcoin-network\
xcopy /s /y libbitcoin-node\*        ..\libbitcoin-node\
xcopy /s /y libbitcoin-protocol\*    ..\libbitcoin-protocol\
xcopy /s /y libbitcoin-server\*      ..\libbitcoin-server\

REM Generate bindings from generated binding generators.
REM The path to swig.exe must be in our path.
REM call ..\libbitcoin\bindings.bat
REM call ..\libbitcoin-blockchain\bindings.bat
REM call ..\libbitcoin-client\bindings.bat
REM call ..\libbitcoin-consensus\bindings.bat
REM call ..\libbitcoin-database\bindings.bat
REM call ..\libbitcoin-explorer\bindings.bat
REM call ..\libbitcoin-network\bindings.bat
REM call ..\libbitcoin-node\bindings.bat
REM call ..\libbitcoin-protocol\bindings.bat
REM call ..\libbitcoin-server\bindings.bat

echo --- OKAY, generation completed.
goto end

:error
echo *** ERROR, generation terminated early.

:end
REM Restore directory.
popd

REM Delay for manual confirmation.
pause
