class Api::BaseController < ApplicationController

  # Don't do regular CSRF protection over the json API, rather just ignore the entire session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user_from_token!, except: ['handle_options_request']

  def default_url_options
    { :host => Rails.application.config.default_host }
  end

  def authenticate_user_from_token!
    unless authenticated_from_token?
      render json: { error: { message: 'Could not authenticate you', code: 32 }},
             status: 401
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: { message: 'You are not authorized to do that.', code: 179 }},
           status: 403
  end

  # These are made by some HTTP Clients wrt CORS. In particular, Ember will make
  # an OPTIONS preflight request when talking to a different domain.
  def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
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
