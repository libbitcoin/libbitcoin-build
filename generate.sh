#   Run code generation
#   Requires iMatix GSL, from http://github.com/imatix/gsl

mkdir -p libbitcoin
mkdir -p libbitcoin-blockchain
mkdir -p libbitcoin-client
mkdir -p libbitcoin-explorer
mkdir -p libbitcoin-node
mkdir -p libbitcoin-protocol
mkdir -p libbitcoin-server

gsl -q generate.xml
