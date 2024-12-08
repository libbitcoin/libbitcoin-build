#!/bin/bash
set -e

YEAR=$(date +%Y)

find . -path '*/.git' -prune -type f -o -type f -name '*' | xargs sed --in-place -e "s/Copyright (c) 20\([0-9][0-9]\)-20[0-9][0-9] libbitcoin/Copyright (c) 20\1-$YEAR libbitcoin/g"
