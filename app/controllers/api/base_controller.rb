class Api::BaseController < ApplicationController

  # Don't do regular CSRF protection over the json API, rather just ignore the entire session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user_from_token!

  def default_url_options
    { :host => Rails.application.config.default_host }
  end

  def authenticate_user_from_token!
    # Find the user using a non-secret token
    if user_email = params[:user_email].presence
      User.find_by_email(user_email)
    elsif device_id = params[:device_id].presence
      User.find_by_email(device_id)
    end

    # Compare using a constant time comparator, mitigating time attacks that could occur
    # if we used an optimized comparison or queried for the user by authentication_token
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    else
      # TODO we need to return 401 / access denied
      raise StandardError.new("Authentication failed")
    end

  end
end
