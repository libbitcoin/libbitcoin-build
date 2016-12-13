.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate libbitcoin interface.swg.
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
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_interface()
for generate.repository by name as _repository
    define my.library = bitcoin_to_include(_repository.name)
    require(_repository, "repository", "name")
    define my.path = "$(_repository.name)/bindings"
    create_directory(my.path)
    define my.out_file = "$(my.path)/$(my.library).swg"
    notify(my.out_file)
    output(my.out_file)

    c_copyleft(_repository.name)
    
    write_line("// TODO: populate interface from headers.")

    close
endfor _repository
endfunction # generate_interface
endtemplate
