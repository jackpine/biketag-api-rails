#!/bin/sh
set -x
docker run --name biketag-api \
           --link biketag-db:biketag-db \
           -p 80:80 \
           -p 443:443 \
           -d jackpine/biketag-api

