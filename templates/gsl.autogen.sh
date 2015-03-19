.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate bindings.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro autogen_content()

autoreconf -i
.
.endmacro # autogen_content
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_autogen()
for generate.repository by name as _repository
    define my.out_file = "$(_repository.name)/autogen.sh"
    notify(my.out_file)
    output(my.out_file)
    
    shebang("bash")
    copyleft(_repository.name)
    autogen_content()

    close
endfor _repository
endfunction # generate_autogen
.endtemplate


