# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Use DatabaseCleaner instead of Rspec to clean the database
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

   config.before(:suite) do
     DatabaseCleaner.strategy = :transaction
     DatabaseCleaner.clean_with(:truncation)
   end

   config.after(:each, type: :requests) do
     DatabaseCleaner.clean_with(:truncation)
   end

   config.around(:each) do |example|
     DatabaseCleaner.cleaning do
       example.run
     end
   end
end

def stub_authentication!
  allow(controller).to receive(:authenticate_user_from_token!)
end

def fake_file
  File.open('db/seeds/images/fake_image.jpg')
end

def uuid_regex
  '\h{8}-\h{4}-\h{4}-\h{4}-\h{12}'
end

def authorization_headers_for_user(user)
  { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Token.encode_credentials(user.api_key.client_id) }
end

def parsed_response
  JSON.parse(response.body)
end

# enforce API error format
RSpec::Matchers.define :have_error do |expected|
  match do |actual|
    parsed_response = JSON.parse(actual.body)
    expect(parsed_response).to have_key("error")
    expect(parsed_response["error"]).to have_key("message")
    expect(parsed_response["error"]["message"]).to include(expected)
  end
end

