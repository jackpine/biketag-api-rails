Hacking
-------

Prerequistes
------------

Install docker. [Installing on a mac](https://docs.docker.com/installation/mac/)
also requires installing boot2docker.

Setup
-----

There are two containers - an app container and a db container.

    localhost$ config/containers/db/run.sh
    localhost$ config/containers/app/run.sh

You should see both a 'biketag-db' and a 'biketag-api' container running.

    $ docker ps

    CONTAINER ID        IMAGE                COMMAND                CREATED STATUS              PORTS                                     NAMES
    0ec405f6cd37        biketag/api:latest   "/sbin/my_init -- ba   54 minutes ago      Up 54 minutes       443/tcp, 80/tcp, 0.0.0.0:3000->3000/tcp   biketag-api
    fdeb68e15f25        biketag/db:latest    "/docker-entrypoint.   58 minutes ago      Up 58 minutes       0.0.0.0:25432->5432/tcp biketag-db

Postgresql starts automataically when the biketag-db container is
started. You can check that it's working by connecting to it.

Keep in mind that when using boot2docker, the containers are running
inside a virtualmachine, so if you want to connect to the container,
it's accessible at `boot2docker ip`, not at `localhost`.

For example, to connect to postgres on biketag-db

    psql -h $(boot2docker ip) -p 25432 --user postgres

You'll have to start the rails server manually. Use the special included
server script to make sure the server is accessible from outside the
container.

    localhost$ config/containers/app/shell.sh
    root@biketag-app$ su - app
    app@biketag-app(~)$ cd ~/biketag-api
    app@biketag-app(~/biketag-api)$ bundle
    app@biketag-app(~/biketag-api)$ bundle exec rake db:setup
    app@biketag-app(~/biketag-api)$ bin/server

At this point you should be able to hit the rails server from your local
machine.

    localhost$ curl $(boot2docker ip):3000

