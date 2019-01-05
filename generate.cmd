@echo off
REM ###########################################################################
REM  Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
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

REM Generate property copiers and artifact generators.
REM gsl -q -script:gsl.copy_modules.sh generate.xml
REM gsl -q -script:gsl.copy_properties.sh generate.xml
REM gsl -q -script:gsl.generate_artifacts.sh generate.xml
gsl -q -script:gsl.copy_modules.cmd generate.xml
gsl -q -script:gsl.copy_properties.cmd generate.xml
gsl -q -script:gsl.generate_artifacts.cmd generate.xml

REM Generate bindings from generated binding generators.
REM The path to swig.exe must be in our path.
REM for generate.repository by name as _repo
REM     call ..\\$(_repo.name)\\bindings.bat
REM endfor

REM Execute property copiers and artifact generators.
call copy_modules.cmd
call copy_properties.cmd
call generate_artifacts.cmd

REM Copy outputs to all repositories.
xcopy /s /y output\* ..\

REM Restore directory.
popd

REM Delay for manual confirmation.
call pause
