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
.   define my.repository_version = _repository.version
.   define my.repository_name = "$(_repository.name:c,upper)"
#ifndef $(my.repository_name)_VERSION_HPP
#define $(my.repository_name)_VERSION_HPP

#define $(my.repository_name)_VERSION "$(my.repository_version)"

#endif
.   close
.endfor _repository
.endmacro # generate_version
.endtemplate


