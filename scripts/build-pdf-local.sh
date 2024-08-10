#!/bin/bash

set -ex

mkdir -p ./dist
cd graypaper

xelatex -halt-on-error -output-directory ../dist ./graypaper.tex 
biber --output-directory ../dist graypaper
xelatex -halt-on-error -output-directory ../dist ./graypaper.tex 
xelatex -halt-on-error -output-directory ../dist ./graypaper.tex 
mv ../dist/graypaper.pdf ../dist/graypaper-${VERSION:-latest}.pdf
cd -
