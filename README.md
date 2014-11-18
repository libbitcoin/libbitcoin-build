[![Build Status](https://travis-ci.org/libbitcoin/libbitcoin-build.svg?branch=master)](https://travis-ci.org/libbitcoin/libbitcoin-build)

# Libbitcoin Build

*Libbitcoin Build System*

Libbitcoin Build uses [iMatix GSL](https://github.com/imatix/gsl) templates and XML data to generate build artifacts for the following libbitcoin libraries.

```
libbitcoin
libbitcoin-blockchain
libbitcoin-client
libbitcoin-explorer
libbitcoin-node
libbitcoin-protocol
libbitcoin-server
```
The artifacts generated for each library are as follows. Package names coincide with libbitcoin repository names.

```
configure.ac
<package>.pc.in
install.sh
.travis.yml
```

The build system has a dependency on [iMatix GSL](https://github.com/imatix/gsl). There are Linux/OSX and Visual Studio builds of GSL. There is also a single file executable available for [download from NuGet](https://github.com/imatix/gsl/blob/master/builds/msvc/README.md).