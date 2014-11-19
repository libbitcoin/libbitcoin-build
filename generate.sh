###############################################################################
# Copyright (c) 2011-2014 libbitcoin developers (see COPYING).
#
# Generate libbitcoin build artifacts from XML + GSL.
#
# This executes the iMatix GSL code generator.
# See https://github.com/imatix/gsl for details.
###############################################################################

copy_to_repository()
{
  CONTENT_PATH="$1"
  REPO_PATH="$2"

  if [ -d "$REPO_PATH" ]; then
    CONTENTS=$(ls -A $CONTENT_PATH)

    if [ "$CONTENTS" ]; then
      cp -r $CONTENT_PATH/* $REPO_PATH/

      if [ -e "$REPO_PATH/install.sh" ]; then
        chmod +x "$REPO_PATH/install.sh"
      fi

      echo "$REPO_PATH updated."
    fi
  else
    echo "$REPO_PATH not found, unable to update."
  fi
}

# Exit this script on the first build error.
set -e

# Make directories for generated build artifacts.
mkdir -p libbitcoin
mkdir -p libbitcoin-blockchain
mkdir -p libbitcoin-client
mkdir -p libbitcoin-explorer
mkdir -p libbitcoin-node
mkdir -p libbitcoin-protocol
mkdir -p libbitcoin-server

# Generate build artifacts.
gsl -q generate.xml

# Copy outputs to all repositories.
copy_to_repository libbitcoin             ../libbitcoin
copy_to_repository libbitcoin-blockchain  ../libbitcoin-blockchain
copy_to_repository libbitcoin-client      ../libbitcoin-client
copy_to_repository libbitcoin-explorer    ../libbitcoin-explorer
copy_to_repository libbitcoin-node        ../libbitcoin-node
copy_to_repository libbitcoin-protocol    ../libbitcoin-protocol
copy_to_repository libbitcoin-server      ../libbitcoin-server

