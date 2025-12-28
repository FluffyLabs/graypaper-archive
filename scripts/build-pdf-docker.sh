#!/bin/bash

set -uex

cd graypaper
if [ "${1:-}" = "nightly" ]; then
  export VERSION="nightly"
else
  export VERSION="$(git rev-parse HEAD)"
fi
cd -

# Fetch docker images
docker build -t gp-pdf-build \
  -f ./scripts/build-pdf.Dockerfile .

# Build PDF first
docker run -v "$(pwd):/workspace" -e VERSION=${VERSION} gp-pdf-build

# Clean up unused files
rm -f ./dist/*.aux ./dist/*.bcf ./dist/*.log ./dist/*.out ./dist/*.xml ./dist/*.synctex ./dist/*.bbl ./dist/*.blg

./scripts/update-metadata.sh ${1:-}
