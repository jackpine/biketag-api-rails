Hacking
-------

Prerequistes
------------

Install docker. [Installing on a mac](https://docs.docker.com/installation/mac/)
also requires installing boot2docker.

#### docker

Install the Kinematic app mentioned in the link above.

#### boot2docker

Use homebrew.

```
$ brew install boot2docker --without-docker
To have launchd start boot2docker at login:
    ln -sfv /usr/local/opt/boot2docker/*.plist ~/Library/LaunchAgents
Then to load boot2docker now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.boot2docker.plist
```

#### Prepare

```
$ boot2docker init
$ boot2docker up
To connect the Docker client to the Docker daemon, please set:
    export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST=tcp://192.168.59.103:2376
$ boot2docker down
$ export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
$ export DOCKER_TLS_VERIFY=1
$ export DOCKER_HOST=tcp://192.168.59.103:2376
$ boot2docker up
```

Setup
-----

There are two containers - an app container and a db container. If you
haven't already built the containers, you'll need to do so:

    me@my-laptop$ config/containers/db/build.sh
    me@my-laptop$ config/containers/api-dev/build.sh

You should now be able to see a biketag/api-dev and a biketag/db image ready
to be run.

    me@my-laptop$ docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
    biketag/api-dev            latest              25c6cb8844bb        About a minute ago   665.9 MB
    biketag/db                 latest              f8d87d188787        6 minutes ago        374.7 MB


Now, to run an instance of your containers

    me@my-laptop$ config/containers/db/run.sh
    me@my-laptop$ config/containers/api-dev/run.sh

You should see both a 'biketag-db' and a 'biketag-api-dev' container running.

    $ docker ps
    CONTAINER ID        IMAGE                    COMMAND                CREATED STATUS                      PORTS                                     NAMES
    0ec405f6cd37        biketag/api-dev:latest   "/sbin/my_init -- ba   54 minutes ago      Up 54 minutes   443/tcp, 80/tcp, 0.0.0.0:3000->3000/tcp   biketag-api-dev
    fdeb68e15f25        biketag/db:latest        "/docker-entrypoint.   58 minutes ago      Up 58 minutes   0.0.0.0:25432->5432/tcp                   biketag-db

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

    me@my-laptop$ config/containers/api-dev/shell.sh
    app@biketag-api-dev(~)$ cd ~/biketag-api-dev
    app@biketag-api-dev(~/biketag-api-dev)$ bundle
    app@biketag-api-dev(~/biketag-api-dev)$ bundle exec rake db:setup
    app@biketag-api-dev(~/biketag-api-dev)$ bin/server

*Note that you can't simply run `bin/rails server` while on boot2docker*

At this point you should be good to go. Verify that you are able to hit
the api server from your local machine.

    me@my-laptop$ curl $(boot2docker ip):3000

If you want to access the app on localhost, rather than remember
boot2docker's ip, you can tunnel port 3000 over ssh.

    me@my-laptop$ boot2docker ssh -L 3000:localhost:3000

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
Provision a single CoreOs Host on Digital Ocean. It needs to have at
least a gig of ram, because, well... fucking ruby (bundle install fails
on allocating memory on the 512mb node). For staging we'll run the DB
and API containers on the same node.

Make these DNS entries

    A     biketag-staging.jackpine.me     -> <Digital Ocean Host IP>
    CNAME api.biketag-staging.jackpine.me -> biketag-staging.jackpine.me
    CNAME db.biketag-staging.jackpine.me  -> biketag-staging.jackpine.me

    me@my-laptop$ bin/deploy core@api.biketag-staging.jackpine.me

Modify the Staging Environment

    core@staging$ docker exec -ti biketag-api bash -l
    root@api-container$ vim ~app/biketag-api/.env

Set up database

    root@api-container$ su - app
    app@api-container$ cd ~/biketag_api
    app@api-container$ RAILS_ENV=production bin/rake db:setup

    # not sure if this is necessaryenv
    root@biketag-api$ sv restart nginx

You should be good to go!

    me@my-laptop$ curl http://api.biketag-staging.jackpine.me/api/v1/games/1/current_spot.json

