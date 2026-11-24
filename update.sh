#!/bin/bash

set -euo pipefail

ARCHIVED="$(git rev-parse HEAD:graypaper)"
git -C graypaper pull
CURRENT="$(git -C graypaper rev-parse HEAD)"

if [[ "$CURRENT" == "$ARCHIVED" &&
      -s "dist/graypaper-$CURRENT.pdf" &&
      -s "dist/graypaper-$CURRENT.md" &&
      -s "dist/graypaper-$CURRENT.synctex.json" &&
      -s "dist/tex-$CURRENT/graypaper.tex" ]] &&
   jq -e --arg hash "$CURRENT" '.latest == $hash and .versions[$hash].hash == $hash' dist/metadata.json >/dev/null; then
  echo "Latest version ($CURRENT) already built."
  exit 0
fi

./scripts/build-pdf-docker.sh

git add -- graypaper dist
git commit -m "Bump graypaper $CURRENT" -- graypaper dist
