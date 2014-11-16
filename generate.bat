@ECHO OFF
REM   Run all code generation scripts
REM   Requires iMatix GSL, from http:\\www.nuget.org\packages\gsl
REM   Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM   Extract gsl.exe from package using NuGet's File > Export

mkdir libbitcoin
mkdir libbitcoin-blockchain
mkdir libbitcoin-client
mkdir libbitcoin-explorer
mkdir libbitcoin-node
mkdir libbitcoin-protocol
mkdir libbitcoin-server

gsl -q generate.xml
PAUSE
