#!/bin/bash

# This script file builds the flutter application for web, on CI/CD
INPUT=".env"

# generate `DART_DEFINES` for web environment
DART_DEFINES="--dart-define=WEB_MODE=true "

while IFS= read -r env_var
do
  DART_DEFINES="$DART_DEFINES--dart-define=$env_var "
done < "$INPUT"

echo -e "Using DART_DEFINES: $DART_DEFINES\n"
eval "flutter build web release $DART_DEFINES"
