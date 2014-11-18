#!/bin/bash
###############################################################################
# Copyright (c) 2011-2014 libbitcoin developers (see COPYING).
#
#         GENERATED SOURCE CODE, DO NOT EDIT EXCEPT EXPERIMENTALLY
#
###############################################################################
# Script to build and install libbitcoin.
#
# Script options:
# --build-gmp              Builds GMP library.
# --build-boost            Builds Boost libraries.
# --build-dir=<path>       Location of downloaded and intermediate files.
# --prefix=<absolute-path> Library install location (defaults to /usr/local).
# --disable-shared         Disables shared library builds.
# --disable-static         Disables static library builds.
#
# Verified on Ubuntu 14.04, requires gcc-4.8 or newer.
# Verified on OSX 10.10, using MacPorts and Homebrew repositories, requires
# Apple LLVM version 6.0 (clang-600.0.54) (based on LLVM 3.5svn) or newer.
# This script does not like spaces in the --prefix or --build-dir, sorry.
# Values (e.g. yes|no) in the boolean options are not supported by the script.
# All command line options are passed to 'configure' of each repo, with
# the exception of the --build-<item> options, which are for the script only.
# Depending on the caller's permission to the --prefix or --build-dir
# directory, the script may need to be sudo'd.

# Define common values.
#==============================================================================
# The default build directory.
#------------------------------------------------------------------------------
BUILD_DIR="libbitcoin-build"

# Boost archives for linux.
#------------------------------------------------------------------------------
BOOST_URL_LINUX="http://sourceforge.net/projects/boost/files/boost/1.49.0/boost_1_49_0.tar.bz2/download"
BOOST_ARCHIVE_LINUX="boost_1_49_0.tar.bz2"

# Boost archives for darwin.
#------------------------------------------------------------------------------
BOOST_URL_DARWIN="http://sourceforge.net/projects/boost/files/boost/1.54.0/boost_1_54_0.tar.bz2/download"
BOOST_ARCHIVE_DARWIN="boost_1_54_0.tar.bz2"

# GMP archives.
#------------------------------------------------------------------------------
GMP_URL="https://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2"
GMP_ARCHIVE="gmp-6.0.0a.tar.bz2"


# Define build options.
#==============================================================================
# Set boost options for linux.
#------------------------------------------------------------------------------
BOOST_OPTIONS=\
"threading=single"\
"variant=release"\
"--disable-icu"\
"--with-date_time"\
"--with-filesystem"\
"--with-regex"\
"--with-system"\
"--with-test"\
"-d0"\
"-q"

# Set boost options for darwin.
#------------------------------------------------------------------------------
BOOST_OPTIONS=\
"toolset=clang"\
"cxxflags=-stdlib=libc++"\
"linkflags=-stdlib=libc++"\
"threading=single"\
"variant=release"\
"--disable-icu"\
"--with-date_time"\
"--with-filesystem"\
"--with-regex"\
"--with-system"\
"--with-test"\
"-d0"\
"-q"

# Set gmp options.
#------------------------------------------------------------------------------
GMP_OPTIONS=\
"CPPFLAGS=-w"

# Set secp256k1 options.
#------------------------------------------------------------------------------
SECP256K1_OPTIONS=\
"CPPFLAGS=-w"\
"--with-bignum=gmp"\
"--with-field=gmp"\
"--enable-benchmark=no"\
"--enable-tests=no"\
"--enable-endomorphism=no"

# Set bitcoin options.
#------------------------------------------------------------------------------
BITCOIN_OPTIONS=\
"--enable-silent-rules"

