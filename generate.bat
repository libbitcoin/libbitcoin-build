@ECHO OFF
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

REM Clean and make directories for generated build artifacts.
rmdir /s /q libbitcoin            2>NUL
rmdir /s /q libbitcoin-blockchain 2>NUL
rmdir /s /q libbitcoin-client     2>NUL
rmdir /s /q libbitcoin-consensus  2>NUL
rmdir /s /q libbitcoin-explorer   2>NUL
rmdir /s /q libbitcoin-node       2>NUL
rmdir /s /q libbitcoin-protocol   2>NUL
rmdir /s /q libbitcoin-server     2>NUL

mkdir libbitcoin
mkdir libbitcoin-blockchain
mkdir libbitcoin-client
mkdir libbitcoin-consensus
mkdir libbitcoin-explorer
mkdir libbitcoin-node
mkdir libbitcoin-protocol
mkdir libbitcoin-server

REM Generate git inputs for GSL scripts.
REM The path to git.exe must be in our path.

REM Generate build artifacts.
gsl -q generate.xml

REM Handle errors below.
if %errorlevel% neq 0 goto error

REM Copy outputs to all repositories.
copy /b /y libbitcoin\*             ..\libbitcoin\
copy /b /y libbitcoin-blockchain\*  ..\libbitcoin-blockchain\
copy /b /y libbitcoin-client\*      ..\libbitcoin-client\
copy /b /y libbitcoin-consensus\*   ..\libbitcoin-consensus\
copy /b /y libbitcoin-explorer\*    ..\libbitcoin-explorer\
copy /b /y libbitcoin-node\*        ..\libbitcoin-node\
copy /b /y libbitcoin-protocol\*    ..\libbitcoin-protocol\
copy /b /y libbitcoin-server\*      ..\libbitcoin-server\

REM Generate bindings from generated binding generators.
REM The path to swig.exe must be in our path.
REM call ..\libbitcoin\bindings.bat
REM call ..\libbitcoin-blockchain\bindings.bat
REM call ..\libbitcoin-client\bindings.bat
REM call ..\libbitcoin-consensus\bindings.bat
REM call ..\libbitcoin-explorer\bindings.bat
REM call ..\libbitcoin-node\bindings.bat
REM call ..\libbitcoin-protocol\bindings.bat
REM call ..\libbitcoin-server\bindings.bat

echo --- OKAY, generation completed.
goto end

:error
echo *** ERROR, generation terminated early.
exit /b %errorlevel%

:end
REM Restore directory.
popd

REM Delay for manual confirmation.
pause
