API Docs
========

Errors
------
API Errors are presents as following:
    { "error": { "message": "some descriptive message string", "code": 123 }}

### Codes

    32  - could not authenticate you
    133 - unable to save spot
    143 - unable to save guess

Hacking
=======

Prerequisites
------------

Install docker. [Installing on a mac](https://docs.docker.com/installation/mac/)
also requires installing boot2docker.

#### docker

Install the Kitematic app mentioned in the link above.

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
$ echo "export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376" >> ~/.bashrc
$ boot2docker up
```

Setup
-----

There are two containers - an app container and a db container.

Start the db container first, like this

```
me@my-laptop$ config/containers/db/run.sh
```

Postgresql starts automatically when the biketag-db container is
started. You can open a sql shell on the container like this

```
me@my-laptop$ docker exec -ti biketag-db psql --user postgres
```

Now, we're going to start the api container. If you just want to stand
up the server to talk to the app, run the regular api container.

```
me@my-laptop$ config/containers/api/run.sh
```

However, if you are going to be developing the api, run the api-dev container
instead.

```
me@my-laptop$ config/containers/api-dev/run.sh
```

BEGINHACK

On the api-dev container, to get file permssions correct, you'll
have to change the uid of the app user to correspond to your local users
id.

```
me@my-laptop$ docker exec -ti biketag-api-dev bash -l
root@api-container$ ls -l /home/app/biketag-api
# see what UID owns these files. Should be the same as the uid for me@my-laptop
# change the UID of the app user to correspond to the files owner
root@api-container$ vim /etc/passwd
```
ENDHACK

You should see both a 'biketag-db' and a 'biketag-api' (or 'biketag-api-dev') container running.

```
me@my-laptop$ docker ps
CONTAINER ID        IMAGE                         COMMAND                CREATED              STATUS              PORTS                           NAMES
c33980290eda        jackpine/biketag-api:latest   "/sbin/my_init"        32 seconds ago       Up 31 seconds       443/tcp, 0.0.0.0:3000->80/tcp   biketag-api-dev
28567df81604        jackpine/biketag-api:latest   "/sbin/my_init"        About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 443/tcp     biketag-api
c27445952259        mdillon/postgis:latest        "/docker-entrypoint.   2 minutes ago        Up 2 minutes        0.0.0.0:25432->5432/tcp         biketag-db
```

*Now that your containers have been provisioned ("run"), unless the
containers are destroyed, you'll only need to `docker start <container>`, 
not `docker run <container>`.*

You'll need to set up your database before the application will work.

```
me@my-laptop$ docker exec -ti biketag-api bash -l  (or biketag-api-dev if you're developing)
root@api-container$ su - app
app@api-container$ cd ~/biketag-api
app@api-container$ RAILS_ENV=production bin/rake db:setup (omit the RAILS_ENV if you're using biketag-api-dev)
```

At this point you should be good to go. Verify that you are able to hit
the api server from your local machine.

```
me@my-laptop$ curl $(boot2docker ip)/api/v1/games/1/current_spot.json
```

Or if you're in development

```
me@my-laptop$ curl $(boot2docker ip):3000/api/v1/games/1/current_spot.json
```

Debugging
---------

To open a shell on the api container

```
me@my-laptop$ docker exec -ti biketag-api bash -l
```

If the application cannot start, check `/var/log/nginx/`
If the application does start, check `~app/biketag-api/logs/`

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

