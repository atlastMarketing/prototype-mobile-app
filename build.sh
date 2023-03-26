#!/bin/bash

# This script file uses the `generate_dart_defines.sh` script to build the flutter application
# Script accepts following arguments:
#   $1 - build artifact [apk|appbundle|ios]
#   $2 - build type [release|debug|profile]
#   $3 - build environment [dev|staging|prod]

# check that all required arguments exist
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo -e "Missing arguments: [apk|appbundle|ios] [release|debug|profile] [dev|staging|prod]"
  exit 128
fi

# generate `DART_DEFINES` for the given build environment
DART_DEFINES=$(scripts/generate_dart_defines.sh $3)

if [ $? -ne 0 ]; then
  echo -e "Failed to generate DART_DEFINE"
  exit 1
fi

echo -e "Using DART_DEFINES: $DART_DEFINES\n"

# eval "flutter build $1 --$2 --flavor $3 $DART_DEFINES"
eval "flutter build $1 --$2 $DART_DEFINES"
