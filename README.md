Hacking
-------

Prerequistes
------------

Install docker. [Installing on a mac](https://docs.docker.com/installation/mac/)
also requires installing boot2docker.

Setup
-----

There are two containers - an app container and a db container. If you
haven't already built the containers, you'll need to do so:

    localhost$ cd config/containers/db/
    localhost$ ./build.sh
    localhost$ cd config/containers/app/
    localhost$ ./build.sh

You should now be able to see a biketag/api and a biketag/db image ready
to be run.

    localhost$ docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
    biketag/api                latest              25c6cb8844bb        About a minute ago   665.9 MB
    biketag/db                 latest              f8d87d188787        6 minutes ago        374.7 MB


Now, to run an instance of your containers

    localhost$ config/containers/db/run.sh
    localhost$ config/containers/app/run.sh

You should see both a 'biketag-db' and a 'biketag-api' container running.

    $ docker ps
    CONTAINER ID        IMAGE                COMMAND                CREATED STATUS              PORTS                                     NAMES
    0ec405f6cd37        biketag/api:latest   "/sbin/my_init -- ba   54 minutes ago      Up 54 minutes       443/tcp, 80/tcp, 0.0.0.0:3000->3000/tcp   biketag-api
    fdeb68e15f25        biketag/db:latest    "/docker-entrypoint.   58 minutes ago      Up 58 minutes       0.0.0.0:25432->5432/tcp biketag-db

*Now that your containers have been provisioned, unless the containers
get destroyed, you'll only need to `docker start` the containers, not
`docker run` them.*

Postgresql starts automatically when the biketag-db container is
started. Try connecting to it to ensure it's working.

    psql -h $(boot2docker ip) -p 25432 --user postgres

*Note that we are connecting to the boot2docker VM which hosts are
containers, not to localhost.*

You'll have to start the rails server manually. Use the included server
script to make sure the server is accessible from outside the container.

    localhost$ config/containers/app/shell.sh
    app@biketag-app(~)$ cd ~/biketag-api
    app@biketag-app(~/biketag-api)$ bundle
    app@biketag-app(~/biketag-api)$ bundle exec rake db:setup
    app@biketag-app(~/biketag-api)$ bin/server

At this point you should be good to go. Verify that you are able to hit
the api server from your local machine.

    localhost$ curl $(boot2docker ip):3000

Deployment
==========

Staging
-------

### AWS

 * create s3 bucket 'biketag-staging' (norcal region)
 * create IAM user 'biketag-staging-user'
 * attach an "inline security policy" called 'biketag-staging-uploader' wth a definition like this:
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
Provision a sngle CoreOs Host on Digital Ocean. It needs to have at
least a gig of ram, because, well... fucking ruby (bundle install fails
on allocating memory on the 512mb node). For staging we'll run the DB
and API containers on the same node.

Make these DNS entries

    A     biketag-staging.jackpine.me     -> <Digital Ocean Host IP>
    CNAME api.biketag-staging.jackpine.me -> biketag-staging.jackpine.me
    CNAME db.biketag-staging.jackpine.me  -> biketag-staging.jackpine.me

Copy the repository onto the new node.

    me@my-laptop$ ssh -A core@api.biketag-staging.jackpine.me
    core@staging$ mkdir -p src/biketag
    core@staging$ cd src/biketag
    core@staging$ git clone github.com:michaelkirk/biketag-api.git

Provision the database container

    core@staging$ cd ~/src/biketag/biketag-api
    core@staging$ config/containers/db/build.sh
    core@staging$ config/containers/db/run.sh

Provision the API Container

    # Copy the .env file onto the docker host
    # `.env` **must be present before we build the container**
    me@my-laptop$ scp ~/src/biketag/biketag-api/.env core@api.biketag-staging.jackpine.me:src/biketag/biketag-api

    core@staging$ cd src/biketag/biketag-api/config/containers/api/
    core@staging$ mkdir -p src/app
    core@staging$ sudo ./mount-app-in-context.sh
    core@staging$ build.sh
    core@staging$ run.sh

Stupid Workarounds

    core@staging$ docker exec -ti biketag-api bash -l
    # Get api credentials
    root@api-container$ env | grep DB
    # update database.yml with the correct host/port
    root@api-container$ vim /home/app/biketag-api/config/database.yml
    root@api-container$ sv restart nginx

Set up database

    root@api-container$ cd /home/app/biketag-api
    root@api-container$ RAILS_ENV=production bin/rake db:setup

You should be good to go!

    me@my-laptop$ curl http://api.biketag-staging.jackpine.me:3000/api/v1/games/1/current_spot.json

