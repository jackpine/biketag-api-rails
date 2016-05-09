#!/bin/sh
# This assumes the secrets have been properly mounted into the container.

if [ ! -e/etc/secrets/biketag-api.env ]
then
  echo "Unable to find biketag-api.env!"
  exit 1
fi

echo "Distributing API env"
cp /etc/secrets/biketag-api.env /home/app/biketag-api/.env
chown app:app /home/app/biketag-api/.env
chmod 400 /home/app/biketag-api/.env

