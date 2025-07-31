class UsersController < ApplicationController
  before_action :load_user, except: %i(new create index)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  # GET /users/:id
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  # PUT /users/:id
  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /users
  def index
    @pagy, @users = pagy(User.all, items: Settings.user.items_per_page)
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:error] = t ".error"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".please_log_in"
    store_location
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t ".cannot_edit"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
