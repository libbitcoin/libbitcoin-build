.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate update_repository_artifacts.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.macro generate_artifact()
.   define out_file = "update_repository_artifacts.sh"
.   notify(out_file)
.   output(out_file)
.   shebang("bash")
.   copyleft("libbitcoin-build")

# Exit this script on the first build error.
set -e

declare -a project=( \\
.   for buildgen->repositories.repository by name as _repo
    "$(_repo.name)" \\
.   endfor
    )

declare -a generator=( \\
.   for buildgen->templates.template as _template
    "$(_template.name)" \\
.   endfor
    )

generate_artifacts()
{
    for gen in "\${generator[@]}"
    do
        eval gsl -q -script:templates/\$gen generate.xml
    done
}

mark_executables()
{
    eval chmod +x "output/*/*.sh"
}

# Do everything relative to this file location.
cd `dirname "$0"`

# Generate build artifacts.
generate_artifacts

# Make generated scripts executable.
mark_executables

.endmacro generate_artifact
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

generate_artifact()

.endtemplate
