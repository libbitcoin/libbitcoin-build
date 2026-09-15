[![Continuous Integration Build](https://github.com/libbitcoin/libbitcoin-build/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-build/actions/workflows/ci.yml)

# Libbitcoin Build

*Libbitcoin Build System*

Libbitcoin Build uses templates and XML data to generate build artifacts for the following libbitcoin libraries.

See [MAINTAINED.md](MAINTAINED.md) for a list of artifacts maintained by this project.

* [![libbitcoin-system](https://github.com/libbitcoin/libbitcoin-system/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-system/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-system/master)](https://coveralls.io/github/libbitcoin/libbitcoin-system?branch=master) libbitcoin-system
* [![libbitcoin-database](https://github.com/libbitcoin/libbitcoin-database/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-database/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-database/master)](https://coveralls.io/github/libbitcoin/libbitcoin-database?branch=master) libbitcoin-database
* [![libbitcoin-network](https://github.com/libbitcoin/libbitcoin-network/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-network/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-network/master)](https://coveralls.io/github/libbitcoin/libbitcoin-network?branch=master) libbitcoin-network
* [![libbitcoin-node](https://github.com/libbitcoin/libbitcoin-node/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-node/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-node/master)](https://coveralls.io/github/libbitcoin/libbitcoin-node?branch=master) libbitcoin-node
* [![libbitcoin-server](https://github.com/libbitcoin/libbitcoin-server/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-server/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-server/master)](https://coveralls.io/github/libbitcoin/libbitcoin-server?branch=master) libbitcoin-server
* [![libbitcoin-explorer](https://github.com/libbitcoin/libbitcoin-explorer/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-explorer/actions/workflows/ci.yml) [![Coverage Status](https://img.shields.io/coveralls/github/libbitcoin/libbitcoin-explorer/master)](https://coveralls.io/github/libbitcoin/libbitcoin-explorer?branch=master) libbitcoin-explorer

The artifacts generated for each library are as follows. Package names coincide with libbitcoin repository names.

```
.github/workflows/ci.yml
.github/workflows/ci-expanded.yml
.gitignore
.vscode/settings.json
builds/gnu/Makefile.am
builds/gnu/configure.ac
builds/gnu/install-gnu.sh
builds/gnu/[library].pc.in
builds/gnu/test_runner.sh
builds/cmake/CMakeLists.txt
builds/cmake/CMakePresets.json
builds/cmake/install-cmake.sh
builds/cmake/install-presets.sh
builds/cmake/[library]-config.cmake.in
builds/msvc/build-msvc.cmd
builds/msvc/debug.natvis
builds/msvc/nuget.config
builds/msvc/build/build_base.bat
builds/msvc/[edition]/[library]/[library].props
builds/msvc/[edition]/[library]/[library].vcxproj
builds/msvc/[edition]/[library]/[library].vcxproj.filters
builds/msvc/[edition]/[library]/packages.config
builds/msvc/[edition]/[library].import.props
builds/msvc/[edition]/[library].import.xml
builds/msvc/[edition]/[library].sln
builds/vscode/[suffix].code-workspace
include/bitcoin/[suffix].hpp
include/bitcoin/[suffix]/version.hpp
```

`[edition]` is currently `vs2022` or `vs2026`. `[library]` is the full repository name (e.g. `libbitcoin-database`); `[suffix]` is the repository name without the `libbitcoin-` prefix (e.g. `database`). See [MAINTAINED.md](MAINTAINED.md) for the exact, per-repository file list.

These artifacts are merged into their respective repositories by libbitcoin maintainers. There is no need to build libbitcoin-build if you are not a maintainer in the process of applying a build configuration change.

### Quick Start

This is similar to the [ci.yml](https://github.com/libbitcoin/libbitcoin-build/blob/master/.github/workflows/ci.yml) workflow and is useful for local generation. In addition to `generate4.sh` there is a `generate4.cmd` for the native Windows environment.

#### Linux
```
# Create a top-level work_directory.
work_directory=$HOME/work
mkdir -p $work_directory
cd $work_directory

# Clone, build and install the gsl dependency.
# gsl requires pcre package (e.g. libpcre3-dev)
# On Ubuntu: sudo apt-get install libpcre3-dev
git clone https://github.com/zeromq/gsl.git
cd gsl/src
make && sudo make install
cd ../../

# Clone all libbitcoin repositories.
git clone https://github.com/libbitcoin/libbitcoin-system.git
git clone https://github.com/libbitcoin/libbitcoin-build.git
git clone https://github.com/libbitcoin/libbitcoin-database.git
git clone https://github.com/libbitcoin/libbitcoin-network.git
git clone https://github.com/libbitcoin/libbitcoin-node.git
git clone https://github.com/libbitcoin/libbitcoin-server.git
git clone https://github.com/libbitcoin/libbitcoin-explorer.git

# Run the libbitcoin-build generation script.
# Newly generated build files are copied to the cloned repos.
cd libbitcoin-build
./generate4.sh
```
#### Windows
```
# Create a top-level work_directory.
set work_directory=%USERPROFILE%\work
if not exist %work_directory% mkdir %work_directory%
cd %work_directory%

# Clone all libbitcoin repositories.
git clone https://github.com/libbitcoin/libbitcoin-system.git
git clone https://github.com/libbitcoin/libbitcoin-build.git
git clone https://github.com/libbitcoin/libbitcoin-database.git
git clone https://github.com/libbitcoin/libbitcoin-network.git
git clone https://github.com/libbitcoin/libbitcoin-node.git
git clone https://github.com/libbitcoin/libbitcoin-server.git
git clone https://github.com/libbitcoin/libbitcoin-explorer.git

# Download the gsl dependency manually from 
# https://github.com/imatix/gsl/releases/download/NuGet-4.1.0.1/gsl.exe.
# Copy the gsl.exe manually to the libbitcoin-build folder in your work 
# directory. 

# Run the libbitcoin-build generation script.
# Newly generated build files are copied to the cloned repos.
cd libbitcoin-build
./generate4.cmd
```
