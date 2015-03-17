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

# Clean and make directories for generated build artifacts.
rm -rf libbitcoin
rm -rf libbitcoin-blockchain
rm -rf libbitcoin-client
rm -rf libbitcoin-consensus
rm -rf libbitcoin-explorer
rm -rf libbitcoin-node
rm -rf libbitcoin-protocol
rm -rf libbitcoin-server

mkdir libbitcoin
mkdir libbitcoin-blockchain
mkdir libbitcoin-client
mkdir libbitcoin-consensus
mkdir libbitcoin-explorer
mkdir libbitcoin-node
mkdir libbitcoin-protocol
mkdir libbitcoin-server

# Generate build artifacts.
gsl -q generate.xml

# Copy outputs to all repositories.
cp -r  libbitcoin             ../libbitcoin
cp -r  libbitcoin-blockchain  ../libbitcoin-blockchain
cp -r  libbitcoin-client      ../libbitcoin-client
cp -r  libbitcoin-consensus   ../libbitcoin-consensus
cp -r  libbitcoin-explorer    ../libbitcoin-explorer
cp -r  libbitcoin-node        ../libbitcoin-node
cp -r  libbitcoin-protocol    ../libbitcoin-protocol
cp -r  libbitcoin-server      ../libbitcoin-server

# Make root scripts executable.
chmod +x ../libbitcoin/*.sh
chmod +x ../libbitcoin-blockchain/*.sh
chmod +x ../libbitcoin-client/*.sh
chmod +x ../libbitcoin-consensus/*.sh
chmod +x ../libbitcoin-explorer/*.sh
chmod +x ../libbitcoin-node/*.sh
chmod +x ../libbitcoin-protocol/*.sh
chmod +x ../libbitcoin-server/*.sh

# Generate bindings from generated binding generators.
# TODO: The path to swig must be in our path.
# source ../libbitcoin/bindings.sh
# source ../libbitcoin-blockchain/bindings.sh
# source ../libbitcoin-client/bindings.sh
# source ../libbitcoin-consensus/bindings.sh
# source ../libbitcoin-explorer/bindings.sh
# source ../libbitcoin-node/bindings.sh
# source ../libbitcoin-protocol/bindings.sh
# source ../libbitcoin-server/bindings.sh
