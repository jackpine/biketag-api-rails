class Api::V1::UsersController < Api::BaseController
  def show
    @user = User.find(params[:id])
  end
end
