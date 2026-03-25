#!/bin/bash

set -uex

cd graypaper
VERSION="$(git rev-parse HEAD)"
export VERSION
cd -

# If this is a nightly build, clean up previous nightly files
if [ "${1:-}" = "nightly" ]; then
  OLD_NIGHTLY_HASH=$(jq -r '.nightly.hash // ""' ./dist/metadata.json)
  if [ -n "$OLD_NIGHTLY_HASH" ]; then
    # Only clean up if the old hash is not a released version
    IS_RELEASED=$(jq -r --arg hash "$OLD_NIGHTLY_HASH" '.versions[$hash] // empty' ./dist/metadata.json)
    if [ -z "$IS_RELEASED" ]; then
      rm -f "./dist/graypaper-${OLD_NIGHTLY_HASH}.pdf"
      rm -f "./dist/graypaper-${OLD_NIGHTLY_HASH}.md"
      rm -f "./dist/graypaper-${OLD_NIGHTLY_HASH}.synctex.json"
      rm -rf "./dist/tex-${OLD_NIGHTLY_HASH}"
    fi
  fi
  # One-time cleanup of legacy literal "nightly" named files
  rm -f "./dist/graypaper-nightly.pdf"
  rm -f "./dist/graypaper-nightly.md"
  rm -f "./dist/graypaper-nightly.synctex.json"
  rm -rf "./dist/tex-nightly"
fi

# Fetch docker images
docker build -t gp-pdf-build \
  -f ./scripts/build-pdf.Dockerfile .

# Build PDF first
docker run -v "$(pwd):/workspace" -e VERSION=${VERSION} gp-pdf-build

# Clean up unused files
rm -f ./dist/*.aux ./dist/*.bcf ./dist/*.log ./dist/*.out ./dist/*.xml ./dist/*.synctex ./dist/*.bbl ./dist/*.blg

./scripts/update-metadata.sh ${1:-}
