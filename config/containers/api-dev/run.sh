#!/usr/bin/env bash
set -x

BIN_DIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
APP_ROOT=$BIN_DIR/../../../

docker run --name biketag-api-dev \
           -v $APP_ROOT:/home/app/biketag-api \
           --link biketag-db:biketag-db \
           -p 3000:80 \
           -e PASSENGER_APP_ENV=development \
           -d jackpine/biketag-api

