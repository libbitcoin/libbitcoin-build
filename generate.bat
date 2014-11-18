@ECHO OFF
REM ###########################################################################
REM  Copyright (c) 2011-2014 libbitcoin developers (see COPYING).
REM 
REM  Generate libbitcoin build artifacts from XML + GSL.
REM 
REM  This executes the iMatix GSL code generator.
REM  See https://github.com/imatix/gsl for details.
REM
REM  Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM  Extract gsl.exe from package using NuGet's File > Export
REM ###########################################################################

REM Make directories for generated build artifacts.
mkdir libbitcoin
mkdir libbitcoin-blockchain
mkdir libbitcoin-client
mkdir libbitcoin-explorer
mkdir libbitcoin-node
mkdir libbitcoin-protocol
mkdir libbitcoin-server

REM Generate build artifacts.
gsl -q generate.xml

REM Copy outputs to all repositories.
copy /b /y libbitcoin\*             ..\libbitcoin\
copy /b /y libbitcoin-blockchain\*  ..\libbitcoin-blockchain\
copy /b /y libbitcoin-client\*      ..\libbitcoin-client\
copy /b /y libbitcoin-explorer\*    ..\libbitcoin-explorer\
copy /b /y libbitcoin-node\*        ..\libbitcoin-node\
copy /b /y libbitcoin-protocol\*    ..\libbitcoin-protocol\
copy /b /y libbitcoin-server\*      ..\libbitcoin-server\

PAUSE
