[![Continuous Integration](https://github.com/libbitcoin/libbitcoin-build/actions/workflows/ci.yml/badge.svg?branch=master&event=push)](https://github.com/libbitcoin/libbitcoin-build/actions/workflows/ci.yml)

# libbitcoin-build

Generates the build, CI and install files of the libbitcoin repositories from one XML manifest, using iMatix GSL templates.

Documentation is at [libbitcoin.org/lib/build](https://libbitcoin.org/lib/build.html).

Download [Bitcoin Server (`bs`)](https://libbitcoin.org/download/index.html).

This is a maintainer tool. Everything it generates is committed to each repository, so building a library or `bs` does not require it.

| | |
| - | - |
| Generates for | libbitcoin-system, -database, -network, -node, -server and -explorer |
| Manifest | `version4.xml` |
| Templates | [iMatix GSL](https://github.com/zeromq/gsl) |
| Run | `generate4.sh` (`generate4.cmd` on Windows) |
| Generated files | [MAINTAINED.md](MAINTAINED.md) |

Libbitcoin is a set of cross-platform C++20 libraries for building Bitcoin applications. See [all libraries](https://libbitcoin.org/lib/index.html) and [building from source](https://libbitcoin.org/building/index.html).

## License

[AGPL with a lesser clause](COPYING).
