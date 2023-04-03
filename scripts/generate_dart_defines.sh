#!/bin/bash

# Flutter allows environmental variables to be defined using `--dart-define`` during run/build
#   eg: `flutter run --dart-define=SOME_VAR=SOME_VALUE --dart-define=OTHER_VAR=OTHER_VALUE``

# This script automates the process of generating the `--dart-define` string based on a `.env` file
# Script accepts following arguments:
#   $1 - environment [dev|staging|prod]
#   #2 - optional web tag [web]

# check that all required arguments exist
if [ -z "$1" ]; then
  echo -e "Missing arguments: [dev|staging|prod]"
  exit 128
fi

case "$1" in

  "staging") INPUT="env/.env.staging";;

  "prod") INPUT="env/.env.production" ;;

  *) INPUT="env/.env.development" ;;

esac

while IFS= read -r env_var
do
  DART_DEFINES="$DART_DEFINES--dart-define=$env_var "
done < "$INPUT"

if [ "$2" == "web" ]; then
  DART_DEFINES="$DART_DEFINES--dart-define=WEB_MODE=true "
fi

echo "$DART_DEFINES"
