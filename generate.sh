#!/bin/bash
###############################################################################
# Copyright (c) 2014-2019 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
cd `dirname "$0"`

# Clean directories for generated build artifacts.
eval rm -rf "output"

# Generate property copiers and artifact generators.
eval gsl -q -script:gsl.copy_modules.sh generate.xml
eval gsl -q -script:gsl.copy_properties.sh generate.xml
eval gsl -q -script:gsl.generate_artifacts.sh generate.xml

# Generate bindings from generated binding generators.
# The path to swig must be in our path.
# for generate.repository by name as _repo
#     eval ../$(_repo.name)/bindings.sh
# endfor

# Make property copiers and artifact generators executable.
eval chmod +x copy_modules.sh
eval chmod +x copy_properties.sh
eval chmod +x generate_artifacts.sh

# Execute property copiers and artifact generators.
eval ./copy_modules.sh
eval ./copy_properties.sh
eval ./generate_artifacts.sh

# Copy outputs to all repositories.
eval cp -rf "output/." "../"
