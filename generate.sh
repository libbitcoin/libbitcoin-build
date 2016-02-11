#!/bin/sh
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

# Do everything relative to this file location.
cd `dirname "$0"`

# Clean directories for generated build artifacts.
rm -rf libbitcoin
rm -rf libbitcoin-blockchain
rm -rf libbitcoin-client
rm -rf libbitcoin-consensus
rm -rf libbitcoin-database
rm -rf libbitcoin-explorer
rm -rf libbitcoin-network
rm -rf libbitcoin-node
rm -rf libbitcoin-protocol
rm -rf libbitcoin-server

# Generate build artifacts.
gsl -q generate.xml

# Make generated scripts executable.
chmod +x libbitcoin/*.sh
chmod +x libbitcoin-blockchain/*.sh
chmod +x libbitcoin-client/*.sh
chmod +x libbitcoin-consensus/*.sh
chmod +x libbitcoin-database/*.sh
chmod +x libbitcoin-explorer/*.sh
chmod +x libbitcoin-network/*.sh
chmod +x libbitcoin-node/*.sh
chmod +x libbitcoin-protocol/*.sh
chmod +x libbitcoin-server/*.sh

# Copy outputs to all repositories.
cp -rf  libbitcoin/.             ../libbitcoin
cp -rf  libbitcoin-blockchain/.  ../libbitcoin-blockchain
cp -rf  libbitcoin-client/.      ../libbitcoin-client
cp -rf  libbitcoin-consensus/.   ../libbitcoin-consensus
cp -rf  libbitcoin-database/.    ../libbitcoin-database
cp -rf  libbitcoin-explorer/.    ../libbitcoin-explorer
cp -rf  libbitcoin-node/.        ../libbitcoin-node
cp -rf  libbitcoin-network/.     ../libbitcoin-network
cp -rf  libbitcoin-protocol/.    ../libbitcoin-protocol
cp -rf  libbitcoin-server/.      ../libbitcoin-server

# Generate bindings from generated binding generators.
# The path to swig must be in our path.
# source ../libbitcoin/bindings.sh
# source ../libbitcoin-blockchain/bindings.sh
# source ../libbitcoin-client/bindings.sh
# source ../libbitcoin-consensus/bindings.sh
# source ../libbitcoin-database/bindings.sh
# source ../libbitcoin-explorer/bindings.sh
# source ../libbitcoin-node/bindings.sh
# source ../libbitcoin-node/network.sh
# source ../libbitcoin-protocol/bindings.sh
# source ../libbitcoin-server/bindings.sh

