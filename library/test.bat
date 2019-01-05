@ECHO OFF
REM ###########################################################################
REM  Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
REM 
REM  Test libbitcoin build collection utilities.
REM 
REM  This executes the iMatix GSL code generator.
REM  See https://github.com/imatix/gsl for details.
REM
REM  Direct GSL download https://www.nuget.org/api/v2/package/gsl/4.1.0.1
REM  Extract gsl.exe from package using NuGet's File > Export
REM ###########################################################################

gsl math_test.gsl
gsl string_test.gsl
gsl collections_test.gsl

pause
