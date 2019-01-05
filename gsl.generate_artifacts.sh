.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate generate_artifacts.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Generation
###############################################################################
.endtemplate
.template 1
.macro generate_artifacts()
.   define out_file = "generate_artifacts.sh"
.   notify(out_file)
.   output(out_file)
.   shebang("bash")
.   copyleft("libbitcoin-build")

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
cd `dirname "$0"`

declare -a generator=( \\
.   for generate->templates.template as _template
    "$(_template.name)" \\
.   endfor
    )

# Generate build artifacts.
for generate in "\${generator[@]}"
do
    gsl -q -script:templates/\$generate generate.xml
done

# Make generated scripts executable.
eval chmod +x "output/*/*.sh"

.endmacro generate_artifacts
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

generate_artifacts()

.endtemplate
