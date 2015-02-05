.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate libbitcoin version.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Generation
###############################################################################
.endtemplate
.template 1
.macro generate_version()
.for generate.repository by name as _repository
.   define my.out_file = "$(_repository.name)/version.hpp"
.   notify(my.out_file)
.   output(my.out_file)
.   c_copyleft(_repository.name)
.   define my.package_version = _repository.version
.   define my.package_name = "$(_repository->package.name:c,upper)"
#ifndef $(my.package_name)_VERSION_HPP
#define $(my.package_name)_VERSION_HPP

#define $(my.package_name)_VERSION "$(my.package_version)"

#endif
.   close
.endfor _repository
.endmacro # generate_version
.endtemplate


