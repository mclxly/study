class ApplicationController < ActionController::Base
  before_action :default_url_options
  before_action :set_i18n_locale_from_params
  before_action :authorize

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    
    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end    
    end

    def set_i18n_locale_from_params
      locale = params[:locale] || I18n.locale
      if I18n.available_locales.map(&:to_s).include?(locale)
        I18n.locale = locale
      else
        flash.now[:notice] = "#{locale} translation not available"
        logger.error flash.now[:notice]
      end
    end

    def default_url_options
      { locale:  params[:locale] || I18n.locale }
    end
end
