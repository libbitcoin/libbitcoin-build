###############################################################################
# Copyright (c) 2011-2014 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

# Exit this script on the first build error.
set -e

# Make directories for generated build artifacts.
mkdir libbitcoin
mkdir libbitcoin-blockchain
mkdir libbitcoin-client
mkdir libbitcoin-explorer
mkdir libbitcoin-node
mkdir libbitcoin-protocol
mkdir libbitcoin-server

# Generate build artifacts.
gsl -q generate.xml

# Make directories for sibling repositories.
mkdir ../libbitcoin
mkdir ../libbitcoin-blockchain
mkdir ../libbitcoin-client
mkdir ../libbitcoin-explorer
mkdir ../libbitcoin-node
mkdir ../libbitcoin-protocol
mkdir ../libbitcoin-server

# Copy outputs to all repositories.
cp libbitcoin/*             ../libbitcoin/
cp libbitcoin-blockchain/*  ../libbitcoin-blockchain/
cp libbitcoin-client/*      ../libbitcoin-client/
cp libbitcoin-explorer/*    ../libbitcoin-explorer/
cp libbitcoin-node/*        ../libbitcoin-node/
cp libbitcoin-protocol/*    ../libbitcoin-protocol/
cp libbitcoin-server/*      ../libbitcoin-server/

chmod +x ../libbitcoin/install.sh
chmod +x ../libbitcoin-blockchain/install.sh
chmod +x ../libbitcoin-client/install.sh
chmod +x ../libbitcoin-explorer/install.sh
chmod +x ../libbitcoin-node/install.sh
chmod +x ../libbitcoin-protocol/install.sh
chmod +x ../libbitcoin-server/install.sh
