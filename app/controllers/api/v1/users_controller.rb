class Api::V1::UsersController < Api::BaseController
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.order(:id)
  end

  def update
    @user = User.find(params[:id])
    authorize! :edit, @user
    if @user.update_attributes(user_params)
      render action: :show
    else
      render json: { error: { code: 133, message: @user.errors.full_messages.join(',') }},
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
