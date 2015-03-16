.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate bindings.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################  

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro bindings_content_bat(interface)
REM Script to build language bindings for $(my.interface) c++ public interfaces.
REM This script requires SWIG - "Simplified Wrapper and Interface Generator".
REM SWIG is a simple tool available for most platforms at http://www.swig.org
REM Add the path to swig.exe to the path of this process or your global path.

echo Generating $(my.interface) bindings...

REM Do everything relative to this file location.
pushd %~dp0

REM Clean and make required directories.
rmdir /s /q "bindings\\java\\wrap" 2>NUL
rmdir /s /q "bindings\\java\\proxy\\org\\libbitcoin\\$(my.interface)" 2>NUL
rmdir /s /q "bindings\\python\\wrap" 2>NUL
rmdir /s /q "bindings\\python\\proxy" 2>NUL

mkdir "bindings\\java\\wrap"
mkdir "bindings\\java\\proxy\\org\\libbitcoin\\$(my.interface)"
mkdir "bindings\\python\\wrap"
mkdir "bindings\\python\\proxy"

REM Generate bindings.
swig -c++ -java -outdir "bindings\\java\\proxy\\org\\libbitcoin\\$(my.interface)" -o "bindings\\java\\wrap\\$(my.interface).cpp" "bindings\\$(my.interface).swg"
swig -c++ -python -outdir "bindings\\python\\proxy" -o "bindings\\python\\wrap\\$(my.interface).cpp" "bindings\\$(my.interface).swg"

REM Restore directory.
popd
.
.endmacro # bindings_content_bat
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_bindings_bat()
for generate.repository by name as _repository
    define my.out_file = "$(_repository.name)/bindings.bat"
    notify(my.out_file)
    output(my.out_file)
    
    batch_no_echo()
    bat_copyleft(_repository.name)
    define my.interface = bitcoin_to_include(_repository.name)
    bindings_content_bat(my.interface)

    close
endfor _repository
endfunction # generate_bindings_bat
.endtemplate

