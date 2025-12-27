#!/bin/bash

set -uex

cd graypaper
export GP_DATE="$(git show --no-patch --format=%aD)"
export REAL_HASH="$(git rev-parse HEAD)"
cd -

if [ "${1:-}" = "nightly" ]; then
  jq --arg hash "$REAL_HASH" --arg dat "$GP_DATE" \
    '.nightly = { name: "nightly", hash: $hash, date: $dat }' \
    ./dist/metadata.json > ./dist/temp-metadata.json
else
  jq --arg ver "$VERSION" --arg dat "$GP_DATE" --arg name "$(cat graypaper/VERSION)" \
    '.latest = $ver | .versions += { ($ver) : { name: $name, hash: $ver, date: $dat }}' \
    ./dist/metadata.json > ./dist/temp-metadata.json
fi
mv ./dist/temp-metadata.json ./dist/metadata.json
