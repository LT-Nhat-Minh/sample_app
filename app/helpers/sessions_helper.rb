module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= find_user_from_session(user_id)
    elsif (user_id = cookies.signed[:user_id])
      @current_user ||= find_user_from_cookies(user_id)
    end
    @current_user
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember_signin user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def session_signin user
    forget user
    session[:session_token] = user.create_session_token
    session[:user_id] = user.id
  end

<<<<<<< Updated upstream
=======
  def signin_remember_or_session user
    if params[:session][:remember_me] == "1"
      remember_signin user
    else
      session_signin user
    end
  end

>>>>>>> Stashed changes
  private

  def find_user_from_session user_id
    user = User.find_by(id: user_id)
    return nil if user.nil?
    if session[:session_token].present? &&
       !user.authenticated_with_session?(session[:session_token])
      return nil
    end

    user
  end

  def find_user_from_cookies user_id
    user = User.find_by(id: user_id)
<<<<<<< Updated upstream
    return unless user&.authenticated?(cookies[:remember_token])
=======
    return unless user&.authenticated?(:remember, cookies[:remember_token])
>>>>>>> Stashed changes

    log_in(user)
    user
  end

  def current_user? user
    user == current_user
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
