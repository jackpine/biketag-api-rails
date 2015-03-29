#!/bin/sh
set -x
docker run --name biketag-api \
           --link biketag-db:biketag-db \
           -p 80:80 \
           -d biketag/api

