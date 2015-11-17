class Api::V1::UsersController < Api::BaseController
  def show
    @user = User.find(params[:id])
    @spots = @user.spots
    @guesses = @user.guesses
    @games = @user.games
  end

  def index
    @users = User.all.order(:id).includes(:spots, :guesses, :games)
    @spots = @users.map { |user| user.spots }.flatten
    @guesses = @users.map { |user| user.guesses }.flatten
    @games = @users.map { |user| user.games }.flatten
  end

  def update
    @user = User.find(params[:id])
    authorize! :edit, @user
    if @user.update_attributes(user_params)
      render action: :show
    else
      render json: Api::Error::InvalidRecord.new( @user.errors.full_messages.join(',') ),
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
