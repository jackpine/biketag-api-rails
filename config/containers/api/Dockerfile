FROM phusion/passenger-ruby22:latest
MAINTAINER Michael Kirk <michael@jackpine.me>

# change app users id to coincide with mounted filesystem (using boot2docker)
RUN sed -i s/app:x:9999/app:x:1000/ /etc/passwd
RUN chown -R app /home/app

# Don't install gems as root, and don't put them in the app directory
RUN mkdir /home/app/.bundle
ADD conf/bundle-config /home/app/.bundle/config
ADD conf/bash_alises /home/app/.bash_aliases

CMD ["/sbin/my_init"]
EXPOSE 3000

