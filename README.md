[![Build Status](https://travis-ci.org/libbitcoin/libbitcoin-build.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-build)

# Libbitcoin Build

*Libbitcoin Build System*

Libbitcoin Build uses templates and XML data to generate build artifacts for the following libbitcoin libraries.


* [![libbitcoin](https://travis-ci.org/libbitcoin/libbitcoin.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin) libbitcoin
* [![libbitcoin-blockchain](https://travis-ci.org/libbitcoin/libbitcoin-blockchain.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-blockchain) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-blockchain/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-blockchain) libbitcoin-blockchain
* [![libbitcoin-client](https://travis-ci.org/libbitcoin/libbitcoin-client.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-client) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-client/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-client) libbitcoin-client
* [![libbitcoin-consensus](https://travis-ci.org/libbitcoin/libbitcoin-consensus.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-consensus) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-consensus/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-consensus) libbitcoin-consensus
* [![libbitcoin-database](https://travis-ci.org/libbitcoin/libbitcoin-database.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-database) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-database/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-database) libbitcoin-database
* [![libbitcoin-explorer](https://travis-ci.org/libbitcoin/libbitcoin.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-explorer) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-explorer/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-explorer) libbitcoin-explorer
* [![libbitcoin-network](https://travis-ci.org/libbitcoin/libbitcoin-network.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-network) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-network/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-network) libbitcoin-network
* [![libbitcoin-node](https://travis-ci.org/libbitcoin/libbitcoin-node.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-node) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-node/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-node) libbitcoin-node
* [![libbitcoin-protocol](https://travis-ci.org/libbitcoin/libbitcoin-protocol.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-protocol) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-protocol/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-protocol) libbitcoin-protocol
* [![libbitcoin-server](https://travis-ci.org/libbitcoin/libbitcoin-server.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-server) [![Coverage Status](https://coveralls.io/repos/libbitcoin/libbitcoin-server/badge.svg)](https://coveralls.io/r/libbitcoin/libbitcoin-server) libbitcoin-server

Notes on Badges
* `libitcoin-client` coverage does not reflect the effect of `libitcoin-explorer` network tests.
* `libitcoin-explorer` coverage does not reflect the effect of network tests.
* `libitcoin-network` coverage does not reflect the effect of network tests.
* Current converage is inflated by the fact that only files with some level of coverage are counted.

The artifacts generated for each library are as follows. Package names coincide with libbitcoin repository names.

```
.travis.yml
autogen.sh
configure.ac
install.sh
[library].pc.in
[library]_test_runner.sh
Makefile.am
include/bitcoin/[library].hpp
include/bitcoin/[library]/version.hpp
```

These artifacts are merged into their respective repositories by libbitcoin maintainers. There is no need to build libbitcoin-build if you are not a maintainer in the process of applying a build configuration change.

The build system has a dependency on [iMatix GSL](https://github.com/imatix/gsl). There are Linux/OSX and Visual Studio builds of GSL. There is also a Windows single file executable available for [download](https://github.com/imatix/gsl/releases/download/NuGet-4.1.0.1/gsl.exe).

*Quick Start*

This method has been tested on GNU/Linux only.  It may help as a
simple guide for other platforms.

```
# Create a top-level work_dir
work_dir=$HOME/work

mkdir -p $work_dir
cd $work_dir

# Clone, build and install the gsl dependency
git clone https://github.com/imatix/gsl.git

cd gsl/src
make && sudo make install
cd ../../

# Define all libbitcoin repositories
repos="libbitcoin libbitcoin-server libbitcoin-blockchain \
libbitcoin-node libbitcoin-network libbitcoin-consensus   \
libbitcoin-client libbitcoin-explorer libbitcoin-build    \
libbitcoin-database libbitcoin-protocol"

# Clone all libbitcoin repositories
for repo in $repos; do
    git clone https://github.com/libbitcoin/${repo}.git
done

# Run the libbitcoin-build generate script
cd libbitcoin-build
./generate.sh

# NOTE: The result of this command is newly generated build
# files in the repos that were cloned into $work_dir
```
