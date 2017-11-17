@echo off
REM ###########################################################################
REM  Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
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
pushd %~dp0

REM Generate libbitcoin-build project artifacts.
gsl -q -script:template_wrapper.gsl buildgen.xml
gsl -q -script:gsl_update_repository_artifacts.cmd buildgen.xml
gsl -q -script:gsl_update_repository_artifacts.sh buildgen.xml

REM Generate repository project artifacts.
call update_repository_artifacts.cmd
