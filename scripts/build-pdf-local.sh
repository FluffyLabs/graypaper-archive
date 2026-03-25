#!/bin/bash

set -ex

npm ci

mkdir -p ./dist

cd graypaper
xelatex -halt-on-error -synctex=1 -output-directory ../dist ./graypaper.tex
biber --output-directory ../dist graypaper
xelatex -halt-on-error -synctex=1 -output-directory ../dist ./graypaper.tex
xelatex -halt-on-error -synctex=1 -output-directory ../dist ./graypaper.tex

mkdir -p ../dist/tex
find . -name '*.tex' -exec rsync -R {} ../dist/tex \;
cd -

gzip -d dist/graypaper.synctex.gz
npm exec tsx scripts/synctex-to-json.ts dist/graypaper.synctex dist/graypaper.synctex.json

mv dist/graypaper.pdf dist/graypaper-${VERSION:-latest}.pdf
mv dist/graypaper.synctex.json dist/graypaper-${VERSION:-latest}.synctex.json

rm -rf dist/tex-${VERSION:-latest}
mv dist/tex dist/tex-${VERSION:-latest}

# Generate markdown from LaTeX sources
GP_VERSION=$(cat graypaper/VERSION 2>/dev/null | tr -d '[:space:]' || echo "unknown")
GP_DATE=$(cd graypaper && git show --no-patch --format=%aI 2>/dev/null || echo "unknown")

/workspace/scripts/tex-to-md.sh \
  graypaper \
  /workspace/dist/graypaper-${VERSION:-latest}.md \
  "$GP_VERSION" "$GP_DATE" "${VERSION:-latest}"
