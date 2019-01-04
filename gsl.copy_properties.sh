.template 0
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# GSL generate copy_properties.sh.
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
.macro emit_import_copy(repository, output, import_name)
.   define my.repository = emit_import_copy.repository
.
    for version in "\${vs_version[@]}"
    do
        mkdir -p $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/\$version/
        eval cp -f props/import/$(my.import_name).import.* $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/\$version/
    done

.endmacro
.
.macro emit_project_props_copy(repository, output)
.   define my.repository = emit_project_props_copy.repository
.
    for version in "\${vs_version[@]}"
    do
        mkdir -p $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/\$version/
        eval cp -rf props/project/$(my.repository.name)/* $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/\$version/
    done
    mkdir -p $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/build/
    eval cp -rf props/nuget.config $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/
    eval cp -rf props/build/build_base.bat $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/build/

.endmacro
.
.macro emit_nuget_config_copy(repository, output)
.   define my.repository = emit_nuget_config_copy.repository
.
    for version in "\${vs_version[@]}"
    do
        mkdir -p $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/
        eval cp -rf props/nuget.config $(my.output)/$(canonical_path_name(my.repository))/builds/msvc/
    done

.endmacro
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_artifacts(path_prefix)
    define out_file = "copy_properties.sh"
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
            emit_import_copy(_repository, my.path_prefix, _build.repository)
        endfor
        emit_project_props_copy(_repository, my.path_prefix)
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
