class Api::V1::SessionsController < Api::BaseController
  skip_before_filter :authenticate_user_from_token!

  def create
    user = User.find_for_database_authentication(
      email: session_params[:email]
    )
    return invalid_login_attempt unless user

    if user.valid_password?(session_params[:password])
      @api_key = user.api_key
      respond_to do |format|
        format.json { render action: 'show', status: :created }
      end
      return
    end
    invalid_login_attempt
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: { error: { message: "Unable to authenticate - Wrong email or password.", code: 33 }},
           status: 401
  end
end


