class Api::V1::ApiKeysController < Api::BaseController
  skip_before_action :authenticate_user_from_token!

  def create
    user = User.create_for_game!

    respond_to do |format|
      format.json { render json: { api_key: user.api_key } }
    end
  end

end
