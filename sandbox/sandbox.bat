@ECHO OFF
REM   Run sandbox code generation scripts, useful for experimenting with GSL.
REM   Requires iMatix GSL, from http:\\www.nuget.org\packages\gsl
REM   Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM   Extract gsl.exe from package using NuGet's File > Export

gsl -q sandbox.xml
PAUSE
