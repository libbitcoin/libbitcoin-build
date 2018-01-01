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

REM Clean directories for generated build artifacts.
rmdir /s /q "output" 2>NUL

REM Generate second-stage artifact generators.
gsl -q -script:gsl.update_repository_artifacts.cmd buildgen.xml
gsl -q -script:gsl.update_repository_artifacts.sh buildgen.xml
gsl -q -script:gsl.update_seeded_artifacts.cmd generate.xml
gsl -q -script:gsl.update_seeded_artifacts.sh generate.xml

REM Generate repository project artifacts.
call update_seeded_artifacts.cmd
call update_repository_artifacts.cmd

REM Copy outputs to all repositories.
xcopy /s /y output\* ..\

REM Delay for manual confirmation.
call pause

REM Generate bindings from generated binding generators.
REM The path to swig.exe must be in our path.
REM .   for buildgen->repositories.repository by name as _repo
REM call ..\\$(_repo.name)\\bindings.bat
REM .   endfor

REM Restore directory.
popd
