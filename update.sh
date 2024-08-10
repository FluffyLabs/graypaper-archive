#!/bin/sh

cd graypaper
git pull
cd -
./scripts/build-html-docker.sh

git commit -am "Bump graypaper."
