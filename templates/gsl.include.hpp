.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate libbitcoin include.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################  

# Get all bitcoin headers in our dependencies, since they are chained.
function write_bitcoin_includes(configure)
    define my.configure = write_bitcoin_includes.configure
    for my.configure.dependency as _dependency\
        where is_bitcoin_dependency(_dependency)
        define my.include = bitcoin_to_include(_dependency.name)
        write_include("bitcoin/$(my.include)")
    endfor
endfunction

# This is redundant with private functions of gsl.Makefile.am.
function is_include(product)
    define my.product = is_include.product
    require(my.product, "product", "prefix")
    return my.product.prefix = "include"
endfunction

# TODO: Create sorted graph for bindings interface construction.
function write_all_includes(build)
    define my.build = write_all_includes.build
    for my.build.product as _product where is_include(_product)
        for _product.files as _files
            # TODO
        endfor
    endfor
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro begin_include(repository)
.   define my.repository = begin_include.repository
.   require(my.repository, "repository", "name")
.   define my.include = bitcoin_to_include(my.repository.name)
.   define my.upper_include = "$(my.include:c,upper)"
#ifndef LIBBITCOIN_$(my.upper_include)_HPP
#define LIBBITCOIN_$(my.upper_include)_HPP

// Convenience header that includes everything
// Not to be used internally. For API users.
.endmacro # begin_include
.
.macro end_include()

#endif
.endmacro # end_include
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_include()
for generate.repository by name as _repository

    # TODO: Search [include.path/][summary] => [include.path/][summary.hpp]

    define my.include = bitcoin_to_include(_repository.name)
    define my.out_file = "$(_repository.name)/$(my.include).hpp"
    notify(my.out_file)
    output(my.out_file)

    c_copyleft(_repository.name)
    begin_include(_repository)
    
    write_line("// TODO: populate includes from sources.")
    
    write_bitcoin_includes(_repository->configure)
    write_all_includes(_repository->build)
    end_include()

    close
    
endfor _repository
endfunction # generate_include
endtemplate