.template 0
###############################################################################
# Copyright (c) 2014-2020 libbitcoin developers (see COPYING).
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
.macro emit_initialize(vs)
.   define my.vs = emit_initialize.vs

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
cd `dirname "$0"`

declare -a vs_version=( \\
.   for my.vs.version as _version
    "$(_version.value)" \\
.   endfor
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
.macro emit_cumulative_dependencies(repositories, repository, dependencies)
.   define my.repositories = emit_cumulative_dependencies.repositories
.   define my.repository = emit_cumulative_dependencies.repository
.   define my.dependencies = emit_cumulative_dependencies.dependencies
.
    << project: $(_repository.name) >>
.   for my.dependencies.dependency as _dependency where\
      (count(my.repositories.repository, (count->package.library = _dependency.name)) > 0)
.     define my.match = my.repositories->repository(repository->package.library = _dependency.name)
      << name: $(_dependency.name) repo_name: $(my.match.name) >>
.   endfor
    <</ project: $(_repository.name) >>
.endmacro
.
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

    emit_initialize(generate->vs)

    for generate.repository by name as _repository
        echo(" Evaluating repository: $(_repository.name)")
        new configure as _dependencies
            cumulative_dependencies(_dependencies, generate, _repository)

            for _dependencies.dependency as _dependency where\
              (count(generate.repository,\
                (count->package.library = _dependency.name)) > 0)

                define my.match = generate->repository(\
                  repository->package.library = _dependency.name)

                emit_import_copy(_repository, my.path_prefix, my.match.name)
            endfor
        endnew

        emit_import_copy(_repository, my.path_prefix, _repository.name)

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
