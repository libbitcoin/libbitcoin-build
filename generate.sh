#!/bin/bash
###############################################################################
# Copyright (c) 2014-2025 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

generate_input()
{
    CONFIGURATION=$1
    shift

    echo "Generating for configuration ${CONFIGURATION}..."

    # Generate process scripts (explict enumeration).
    eval gsl -q -script:process/generate_artifacts.sh.gsl ${CONFIGURATION}

    # Make process scripts executable.
    eval chmod +x process/*.sh

    # Execute process scripts (explicit enumeration).
    echo "Generating artifacts for configuration ${CONFIGURATION}..."
    eval ./process/generate_artifacts.sh
    #eval ./copy_projects.sh "$@"
    echo "Generation for configuration ${CONFIGURATION} complete."
}

# Exit this script on the first build error.
set -e

# Do everything relative to this file location.
BUILD_PATH=`dirname "$0"`
pushd ${BUILD_PATH}

generate_input "$@"
