class Api::BaseController < ApplicationController

  # Don't do regular CSRF protection over the json API, rather just ignore the entire session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user_from_token!

  def default_url_options
    { :host => Rails.application.config.default_host }
  end

  def authenticate_user_from_token!
    unless authenticated_from_token?
      render json: { errors: [ { message: "Could not authenticate you", code: 32 } ]},
             status: 401
    end
  end

  def authenticated_from_token?
    authenticate_with_http_token do |token, options|
      api_key = ApiKey.find_by_client_id(token)
      if api_key
        # TODO HMAC
        sign_in api_key.user, store: false
        true
      else
        false
      end
    end
  end
end
