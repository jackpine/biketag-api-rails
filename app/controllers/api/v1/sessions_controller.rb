class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_filter :authenticate_user_from_token!

  def create
    # ensure user wasn't previously created
    user = User.find_by_device_id(session_params[:device_id])
    if user
      raise StandardError.new("This device was already registered");
    else
      user = User.create!(device_id: session_params[:device_id])
      respond_to do |format|
        format.json { render json: user.session }
      end
    end
  end

  def session_params
    params.require(:session).permit(:device_id)
  end
end
