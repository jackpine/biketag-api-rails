class Api::V1::ApiKeysController < Api::BaseController
  skip_before_filter :authenticate_user_from_token!

  def create
    user = nil
    ActiveRecord::Base.transaction do
      user = User.create!
      user.create_api_key!
    end

    respond_to do |format|
      format.json { render json: { api_key: user.api_key } }
    end
  end

end
