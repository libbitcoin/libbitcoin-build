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

gsl -q -script:template_wrapper.gsl buildgen.xml
gsl -q -script:gsl_update_repository_artifacts.cmd buildgen.xml
gsl -q -script:gsl_update_repository_artifacts.sh buildgen.xml

eval chmod +x update_repository_artifacts.sh

eval ./update_repository_artifacts.sh

