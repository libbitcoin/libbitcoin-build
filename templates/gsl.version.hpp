.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate version.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

function split_version(version, version_string)
    define my.version = split_version.version

    define my.position = string.locate(my.version_string, ".")
    define my.version.major = left(my.version_string, my.position)

    define my.remainder = string.substr(my.version_string, my.position + 1)
    define my.position = string.locate(my.remainder, ".")
    define my.version.minor = left(my.remainder, my.position)

    define my.version.patch = string.substr(my.remainder, my.position + 1)
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro render_version(version, upper_repository)
.   define my.version = render_version.version
.   new version as _version
.       split_version(_version, my.version)
#ifndef $(my.upper_repository)_VERSION_HPP
#define $(my.upper_repository)_VERSION_HPP

/**
 * The semantic version of this repository as: [major].[minor].[patch]
 * For interpretation of the versioning scheme see: http://semver.org
 */

#define $(my.upper_repository)_VERSION "$(_version.major).$(_version.minor).$(_version.patch)"
#define $(my.upper_repository)_MAJOR_VERSION $(_version.major)
#define $(my.upper_repository)_MINOR_VERSION $(_version.minor)
#define $(my.upper_repository)_PATCH_VERSION $(_version.patch)

#endif
.   endnew
.endmacro # render_version
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_version(path_prefix)
    for generate.repository by name as _repository
        define my.primary = bitcoin_to_include(_repository.name)
        define my.upper_repository = "$(_repository.name:c,upper)"
        define my.version = _repository.version
        for _repository.make as _make
            for _make.product as _product where is_bitcoin_headers(_product)
                for _product.files as _files

                    # We are writing into local primary includes (not installdir).
                    define my.include = join(join(my.path_prefix,\
                        canonical_path_name(_repository)), _files.path)
                    define my.path = "$(my.include)/$(my.primary)"
                    create_directory(my.path)

                    define my.out_file = "$(my.path)/version.hpp"
                    notify(my.out_file)
                    output(my.out_file)

                    c_copyleft(_repository.name)
                    render_version(my.version, my.upper_repository)

                    close
                endfor _files
            endfor _product
        endfor _make
    endfor _repository
endfunction # generate_version
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

generate_version("output")

.endtemplate
