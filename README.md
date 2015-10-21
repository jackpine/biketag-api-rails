API Docs
========

Errors
------
API Errors are presented as:

    { "error": { "message": "some descriptive message string", "code": 123 }}

See [Api::Error](models/api/error.rb) for the specific errors and their
codes.

Setup
=====

If you just want to run the API (and not develop it), consider using the
BikeTag API docker containers. If you want to add features or fix bugs
in the API, skip to the [hacking](#hacking) section.

Prerequisites
-------------

Install [docker](https://www.docker.com/). The details of installing
Docker are left as an exercise to the reader since the process changes
and varies accross platforms.

Installation
------------

Start the api container

    me@my-laptop$ config/containers/api/run.sh

You can open a shell on the api container like this

    me@my-laptop$ config/containers/api/shell.sh

### Database

Start the db container like this

    me@my-laptop$ config/containers/db/run.sh

Postgresql starts automatically when the biketag-db container is
started. You can open a sql shell on the container like this

    me@my-laptop$ config/containers/db/shell.sh

Check your work with `docker ps`. You should see both a 'biketag-db' and
a 'biketag-api' container running.

    me@my-laptop$ docker ps
    CONTAINER ID        IMAGE                         COMMAND                CREATED              STATUS              PORTS                           NAMES
    c33980290eda        jackpine/biketag-api:latest   "/sbin/my_init"        32 seconds ago       Up 31 seconds       443/tcp, 0.0.0.0:3000->80/tcp   biketag-api-dev
    28567df81604        jackpine/biketag-api:latest   "/sbin/my_init"        About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 443/tcp     biketag-api
    c27445952259        mdillon/postgis:latest        "/docker-entrypoint.   2 minutes ago        Up 2 minutes        0.0.0.0:25432->5432/tcp         biketag-db


Take note of the port biketag-db has forwarded postgres to (25432 in
this case).

*Now that your containers have been provisioned ("run"), unless the
containers are destroyed, you'll only need to `docker start
<container-name>`, not `docker run <container-name>`.*

You'll need to set up your database schema before the application will
work.

```
me@my-laptop$ docker exec -ti biketag-api bash -l
root@api-container$ su - app
app@api-container$ cd ~/biketag-api
app@api-container$ RAILS_ENV=production bin/rake db:setup
```

At this point you should be good to go. Verify that you are able to hit
the api server from your local machine.

  me@my-laptop$ curl $(boot2docker ip)/api/v1/games/1/current_spot.json

Debugging
---------

To open a shell on the api container

   me@my-laptop$ docker exec -ti biketag-api bash -l

If the application cannot start, check `/var/log/nginx/`
If the application does start, check `~app/biketag-api/logs/`

Hacking
=======

Prerequisites
-------------

Install docker and rbenv.

To develop the api, first provision the database container as mentioned
in [Database Setup](#database).

Install the proper ruby version and ruby gems

    me@my-laptop:biketag-api$ rbenv install
    me@my-laptop:biketag-api$ gem install bundler
    me@my-laptop:biketag-api$ bundle
    me@my-laptop:biketag-api$ bin/rake db:setup

At this point you should be good to go. Verify that you are able to hit
the api server from your local machine.

  me@my-laptop$ curl localhost:3000/api/v1/games/1/current_spot.json

Deployment
==========

Staging
-------

### AWS

 * create s3 bucket 'biketag-staging' (norcal region)
 * create IAM user 'biketag-staging'
 * attach an "inline security policy" called 'biketag-staging-uploader' with a 'custom' definition like this:

```
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion",
                "s3:GetObjectVersionAcl",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::biketag-staging/*"
            ]
        }
    ]
}
```


### Digital Ocean
Provision a single CoreOS Host on Digital Ocean. It needs to have at
least a gig of ram, because, well... fucking ruby. For staging we'll run
the DB and API containers on the same node.

Make these DNS entries

```
A     biketag-staging.jackpine.me     -> <Digital Ocean Host IP>
CNAME api.biketag-staging.jackpine.me -> biketag-staging.jackpine.me
CNAME db.biketag-staging.jackpine.me  -> biketag-staging.jackpine.me

me@my-laptop$ bin/deploy core@api.biketag-staging.jackpine.me
```

Modify the Staging Environment

    core@staging$ docker exec -ti biketag-api bash -l
    root@api-container$ vim ~app/biketag-api/.env

Set up database

```
root@api-container$ su - app
app@api-container$ cd ~/biketag_api
app@api-container$ RAILS_ENV=production bin/rake db:setup

# not sure if this is necessary
root@biketag-api$ sv restart nginx
```

You should be good to go!

```
me@my-laptop$ curl http://api.biketag-staging.jackpine.me/api/v1/games/1/current_spot.json
```

