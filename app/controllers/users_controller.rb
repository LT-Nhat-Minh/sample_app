class UsersController < ApplicationController
  before_action :load_user, only: :show

  # GET /users/:id
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit User::USER_PERMIT
  end
end
