class ApplicationController < ActionController::Base
  before_action :set_locale

  private
  def set_locale
    locale = params[:locale].to_s
    if locale.present? && I18n.available_locales.map(&:to_s).include?(locale)
      I18n.locale = locale
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
