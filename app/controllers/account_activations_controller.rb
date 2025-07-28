class AccountActivationsController < ApplicationController
  before_action :get_user, only: :edit

  def edit
    activated = !@user.activated
    valid_token = @user.authenticated?(:activation, params[:id])

    if @user && activated && valid_token
      @user.activate
      log_in @user
      flash[:success] = t ".activated"
      redirect_to @user
    else
      flash[:danger] = t ".invalid_link"
      redirect_to root_url
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end
end
