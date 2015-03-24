#!/bin/sh
set -x
docker run --name biketag-api \
           -v /Users/mkirk/src/biketag/biketag-api:/home/app/biketag-api \
           --link biketag-db:biketag-db \
           -p 3000:3000 \
           -d biketag/api
