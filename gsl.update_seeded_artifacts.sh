.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate update_seeded_artifacts.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro emit_initialize()

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
cd `dirname "$0"`

declare -a vs_version=( \\
    "vs2013" \\
    "vs2015" \\
    "vs2017" \\
    )
    
.endmacro
.
.macro emit_import_copy(output, repository_name, import_name)
    for version in "\${vs_version[@]}"
    do
        mkdir -p $(my.output)/$(my.repository_name)/builds/msvc/\$version/
        eval cp -f import/$(my.import_name).import.* $(my.output)/$(my.repository_name)/builds/msvc/\$version/
    done

.endmacro
.
.macro emit_project_props_copy(output, repository_name)
    for version in "\${vs_version[@]}"
    do
        mkdir -p $(my.output)/$(my.repository_name)/builds/msvc/\$version/
        eval cp -rf seed_projects/$(my.repository_name)/* $(my.output)/$(my.repository_name)/builds/msvc/\$version/
    done

.endmacro
.template 0
###############################################################################
# Generation
###############################################################################
function generate_artifacts(path_prefix)
    define out_file = "update_seeded_artifacts.sh"
    notify(out_file)
    output(out_file)
    shebang("bash")
    copyleft("libbitcoin-build")

    emit_initialize()

# TODO: walk dependency tree, not build list.
# TODO: build list is for telling installer what to compile.
   for generate.repository by name as _repository
       echo(" Evaluating repository: $(_repository.name)")
        for _repository->install.build as _build where\
             defined(_build.repository) & starts_with(_build.repository, "libbitcoin")
            emit_import_copy(my.path_prefix, _repository.name, _build.repository)
       endfor
       emit_project_props_copy(my.path_prefix, _repository.name)
   endfor

endfunction
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

generate_artifacts("output")

.endtemplate
