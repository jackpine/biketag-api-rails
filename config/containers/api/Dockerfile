FROM phusion/passenger-ruby22:latest
MAINTAINER Michael Kirk <michael@jackpine.me>

ENV HOME /root

CMD ["/sbin/my_init"]

RUN rm /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

ADD conf/biketag-api.conf /etc/nginx/sites-enabled/biketag-api.conf

# Docker Database Environment Variables
ADD conf/biketag-db-env.conf /etc/nginx/main.d/biketag-db-env.conf

# Don't re-run bundle install unless Gemfile changes - otherwise if we do it
# *after* we add the app, we'll run bundle install everytime any file in the
# app changes.  Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD src/app/Gemfile /tmp/Gemfile
ADD src/app/Gemfile.lock /tmp/Gemfile.lock
RUN bundle install

ADD src/app /home/app/biketag-api
RUN chown -R app:app /home/app/biketag-api

# Clean up APT when done. 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

