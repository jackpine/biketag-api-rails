class Api::V1::ApiKeysController < Api::BaseController
  skip_before_filter :authenticate_user_from_token!

  def create
    user = User.create_for_game!
    @api_key = user.api_key

    respond_to do |format|
      format.json { render action: 'show', status: :created }
    end
  end

end
