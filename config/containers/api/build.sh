#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $SCRIPT_DIR
docker build -t biketag/api .
