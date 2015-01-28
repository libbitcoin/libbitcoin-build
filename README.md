[![Build Status](https://travis-ci.org/libbitcoin/libbitcoin-build.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-build)

# Libbitcoin Build

*Libbitcoin Build System*

Libbitcoin Build uses templates and XML data to generate build artifacts for the following libbitcoin libraries.

* [![libbitcoin](https://travis-ci.org/libbitcoin/libbitcoin.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin) libbitcoin
* [![libbitcoin-blockchain](https://travis-ci.org/libbitcoin/libbitcoin-blockchain.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-blockchain) libbitcoin-blockchain
* [![libbitcoin-client](https://travis-ci.org/libbitcoin/libbitcoin-client.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-client) libbitcoin-client
* [![libbitcoin-explorer](https://travis-ci.org/libbitcoin/libbitcoin-explorer.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-explorer) libbitcoin-explorer
* [![libbitcoin-node](https://travis-ci.org/libbitcoin/libbitcoin-node.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-node) libbitcoin-node
* [![libbitcoin-protocol](https://travis-ci.org/libbitcoin/libbitcoin-protocol.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-protocol) libbitcoin-protocol
* [![libbitcoin-server](https://travis-ci.org/libbitcoin/libbitcoin-server.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-server) libbitcoin-server

The artifacts generated for each library are as follows. Package names coincide with libbitcoin repository names.

```
configure.ac
<package>.pc.in
install.sh
.travis.yml
```

The build system has a dependency on [iMatix GSL](https://github.com/imatix/gsl). There are Linux/OSX and Visual Studio builds of GSL. There is also a single file executable available for [download from NuGet](https://github.com/imatix/gsl/blob/master/builds/msvc/README.md).
