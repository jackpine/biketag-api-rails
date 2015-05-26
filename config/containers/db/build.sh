#!/usr/bin/env bash
BIN_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cd $BIN_DIR
docker build -t biketag/db .
