.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate version.hpp.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
[global].root = ".."
[global].trace = 0
[gsl].ignorecase = 0

gsl from "utilities.gsl"

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

cleanup_local_files()
{
    eval rm -rf "output"
}

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
#    for proj in "\${project[@]}"
#    do
#        eval chmod +x "output/\$proj/*.sh"
#    done
}

overwrite_project_files()
{
    eval cp -rf "output/." "../"
#    for proj in "\${project[@]}"
#    do
#        eval cp -rf "output\$proj/." "../$\proj"
#    done
}

# Do everything relative to this file location.
cd `dirname "$0"`

# Clean directories for generated build artifacts.
cleanup_local_files

# Generate build artifacts.
generate_artifacts

# Make generated scripts executable.
mark_executables

# Copy outputs to all repositories.
overwrite_project_files

.endmacro generate_artifact
.endtemplate
.template 0

generate_artifact()

.endtemplate
###############################################################################
