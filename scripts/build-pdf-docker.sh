#!/bin/bash

set -uex

cd graypaper
export VERSION="$(git rev-parse HEAD)"
cd -

# Fetch docker images
docker build -t gp-pdf-build \
  -f ./scripts/build-pdf.Dockerfile .

# Build PDF first
docker run -v "$(pwd):/workspace" -e VERSION=${VERSION} -it gp-pdf-build

# Clean up unused files
rm -f ./dist/*.aux ./dist/*.bcf ./dist/*.log ./dist/*.out ./dist/*.xml ./dist/*.synctex ./dist/*.bbl ./dist/*.blg

./scripts/update-metadata.sh
