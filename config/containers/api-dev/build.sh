#!/bin/sh
echo "Run this from your Rails root"
docker build -f Dockerfile.dev -t biketag/api-dev .
