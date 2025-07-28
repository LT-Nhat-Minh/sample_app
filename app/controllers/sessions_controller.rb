class SessionsController < ApplicationController
  before_action :load_user_by_email, only: :create
  before_action :check_authentication, only: :create

  def new; end

  def create
    log_in @user
    if params.dig(:session, :remember_me) == "1"
      remember_signin(@user)
    else
      session_signin(@user)
    end
    redirect_to @user
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def load_user_by_email
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t ".not_found"
    render :new, status: :unprocessable_entity
  end

  def check_authentication
    return if @user.try(:authenticate, params.dig(:session, :password))

    flash.now[:danger] = t ".invalid_email_or_password"
    render :new, status: :unprocessable_entity
  end
end
