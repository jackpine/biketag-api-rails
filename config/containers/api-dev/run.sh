#!/bin/sh
set -x
docker run --name biketag-api-dev \
           -v ~/src/biketag/biketag-api:/home/app/biketag-api-dev \
           --link biketag-db:biketag-db \
           -p 3000:3000 \
           -d jackpine/biketag-api-dev

