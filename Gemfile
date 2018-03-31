source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0', '< 5.1'

gem 'rack-permissive-cors', git: "https://github.com/jackpine/rack-permissive-cors.git"

# dotenv should be inluded before any other gems that use environment
# variables, otherwise those gems will get initialized with the wrong values.
gem 'dotenv-rails'

gem 'pg'
gem 'activerecord-postgis-adapter'
gem 'rgeo-geojson'

gem 'devise'
gem 'cancancan'
gem 'role_model'
gem 'newrelic_rpm'
gem 'tzinfo-data'

gem 'houston'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'paperclip'
gem 'fog-aws'
gem 'fog-local'

# Implicit dependency in our version of paperclip. Results in:
# NameError: uninitialized constant Paperclip::Storage::S3::AWS
# http://stackoverflow.com/questions/28374401/nameerror-uninitialized-constant-paperclipstorages3aws
gem 'aws-sdk'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'pry'
  gem 'pry-byebug'

  gem 'factory_girl_rails'

  # pegged for rails 5 compatibility
  gem 'rspec-rails'
  gem 'guard-rspec', require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec', group: :development
end

group :test do
  gem 'database_cleaner'
end

