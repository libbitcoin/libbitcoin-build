#!/bin/bash
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

# Exit this script on the first build error.
set -e

cleanup_local_files()
{
    eval rm -rf "output"
}

overwrite_project_files()
{
    eval cp -rf "output/." "../"
}

generate_updaters()
{
    eval gsl -q -script:gsl.generate_artifacts.cmd generate.xml
    eval gsl -q -script:gsl.generate_artifacts.sh generate.xml
    eval chmod +x generate_artifacts.sh
    eval gsl -q -script:gsl.copy_properties.cmd generate.xml
    eval gsl -q -script:gsl.copy_properties.sh generate.xml
    eval chmod +x copy_properties.sh

}

execute_updaters()
{
    eval ./copy_properties.sh
    eval ./generate_artifacts.sh
}

# Do everything relative to this file location.
cd `dirname "$0"`

# Clean directories for generated build artifacts.
cleanup_local_files

# Generate second-stage artifact generators.
generate_updaters

# Execute second-stage artifact generation.
execute_updaters

# Copy outputs to all repositories.
overwrite_project_files

