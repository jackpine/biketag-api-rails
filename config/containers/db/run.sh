#!/bin/sh
docker run --name biketag-db -p 25432:5432 -d biketag/db
