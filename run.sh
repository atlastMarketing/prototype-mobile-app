#!/bin/bash

# This script file uses the `generate_dart_defines.sh` script to run the flutter application
#   on a selected device and using a specified environment
# Script accepts following arguments:
#   $1 - build environment [dev|staging|prod]
#   #2 - optional device
#   #3 - optional web tag [web]

RUN_ENV="${1:-dev}"
if [ -z "$1" ]; then
  echo -e "Running using default 'dev' environment"
fi

if [ "$1" == "prod" ]; then
  OPTIONS="--release"
else
  OPTIONS=""
fi

if [ "$2" ]; then
    RUN_DEVICE="-d $2"
else
    RUN_DEVICE=""
fi

# generate `DART_DEFINES` for the given build environment
DART_DEFINES=$(scripts/generate_dart_defines.sh $RUN_ENV $3)

if [ $? -ne 0 ]; then
  echo -e "Failed to generate DART_DEFINE"
  exit 1
fi

echo -e "Using DART_DEFINES: $DART_DEFINES\n"

eval "flutter run $DART_DEFINES $RUN_DEVICE $OPTIONS"
