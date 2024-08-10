#!/bin/bash

cd graypaper
INITIAL="$(git rev-parse HEAD)"
git pull
CURRENT="$(git rev-parse HEAD)"

if [ $INITIAL == $CURRENT ];
then
  echo "Latest version ($CURRENT) already built."
  exit 0
fi
cd -
./scripts/build-html-docker.sh

git commit -am "Bump graypaper."
