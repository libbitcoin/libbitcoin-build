.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate bindings.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Generation
###############################################################################
.macro generate_autogen()
.   for generate.repository by name as _repository
.       require(_repository, "repository", "name")
.       create_directory(_repository.name)
.       define my.out_file = "$(_repository.name)/autogen.sh"
.       notify(my.out_file)
.       output(my.out_file)
.
.       shebang("sh")
.       copyleft(_repository.name)

autoreconf -i
.
.       close
.   endfor _repository
.endmacro # generate_autogen
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

generate_autogen()

.endtemplate
