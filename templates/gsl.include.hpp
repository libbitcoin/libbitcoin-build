.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate bitcoin.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

#------------------------------------------------------------------------------
# Render Local Includes
#------------------------------------------------------------------------------

# Recurse the directory tree, rendering all files.
function render_headers(files, folder, base_trim, path_trim, product)
    define my.files = render_headers.files
    define my.product = render_headers.product
    define my.directory = open_directory(my.folder)
    for my.directory.directory as _directory by _directory.name
        define my.subfolder = "$(_directory.path)$(_directory.name)"
        get_product_files(my.files, my.subfolder, my.base_trim, my.product)
        if (!table_empty(my.files))
            for my.files.row as _row
                write_include(join(my.product.container, _row.name))
            endfor
            table_clear(my.files)
        endif
        render_headers(my.files, my.subfolder, my.base_trim, my.path_trim,\
            my.product)
    endfor
endfunction

# <files>
# Recurse directory tree, render headers for each folder excluding the first.
function render_files_headers(folder, base_trim, path_trim, product)
    define my.product = render_files_headers.product
    new files as _files
        render_headers(_files, my.folder, my.base_trim, my.path_trim,\
            my.product)
    endnew
endfunction

# <files> as include source.
function write_local_includes(files, product, root, repository)
    define my.files = write_local_includes.files
    define my.product = write_local_includes.product
    define my.repository = write_local_includes.repository
    require(my.files, "files", "path")
    define my.folder = "$(my.root)$(my.files.path)/"
    define my.root_length = string.length(my.folder)
    define my.path_length = string.length(my.files.path)
    render_files_headers(my.folder, my.root_length, my.path_length,\
        my.product)
return
endfunction

#------------------------------------------------------------------------------
# Render Bitcoin Includes
#------------------------------------------------------------------------------

# Get all bitcoin headers in our dependencies. Since they are chained and only
# incorporated if not redunant, this yields the minimal necessary set.
function write_bitcoin_includes(configure)
    define my.configure = write_bitcoin_includes.configure
    for my.configure.dependency as _dependency\
        where is_bitcoin_dependency(_dependency)
        define my.option = find_option_symbol(_dependency, my.configure)?
        if (defined(my.option))
            write_line("\n#ifdef $(my.option:upper)")
        endif
        define my.library = bitcoin_to_include(_dependency.name)
        write_include("bitcoin/$(my.library).hpp")
        if (defined(my.option))
            write_line("#endif\n")
        endif
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

/**
 * API Users: Include only this header. Direct use of other headers is fragile
 * and unsupported as header organization is subject to change.
 *
 * Maintainers: Do not include this header internal to this library.
 */

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
function generate_include(path_prefix)
    for generate.repository by name as _repository
        define my.primary = bitcoin_to_include(_repository.name)
        define my.absolute = "$(global.root)/$(canonical_path_name(_repository))"
        define my.base = normalize_directory(my.absolute)
        for _repository.make as _make
            for _make.product as _product where is_headers(_product)
                for _product.files as _files
                    define my.include = join(join(my.path_prefix,\
                        canonical_path_name(_repository)), _files.path)
                    create_directory(my.include)
                    define my.out_file = "$(my.include)/$(my.primary).hpp"
                    notify(my.out_file)
                    output(my.out_file)

                    c_copyleft(_repository.name)
                    begin_include(_repository)

                    if (is_bitcoin_headers(_product))
                        write_bitcoin_includes(_repository->configure)
                    endif
                    write_local_includes(_files, _product, my.base, _repository)

                    end_include()
                    close
                endfor _files
            endfor _product
        endfor _make
    endfor _repository
endfunction # generate_include
.endtemplate
.template 0
###############################################################################
# Execution
###############################################################################
[global].root = ".."
[global].trace = 0
[gsl].ignorecase = 0

# Note: expected context root libbitcoin-build directory
gsl from "library/math.gsl"
gsl from "library/string.gsl"
gsl from "library/collections.gsl"
gsl from "utilities.gsl"

generate_include("output")

.endtemplate
