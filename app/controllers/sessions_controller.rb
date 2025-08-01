class SessionsController < ApplicationController
  before_action :load_user_by_email, only: :create
  before_action :check_authentication, only: :create

  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      if @user.activated
        log_in @user
        signin_remember_or_session @user
        redirect_back_or @user
      else
        flash[:warning] = t ".not_activated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".invalid_email_or_password"
      render :new, status: :unprocessable_entity
    end
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
