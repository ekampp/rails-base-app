require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  self.responder = ApplicationResponder
  respond_to :html, :json

  protect_from_forgery

  # Cache get requests publically and agressively by default
  before_filter :cache_publically, if: :get?

  # Rescue from cancan access denied exception
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug{ "REscuing from cancan access denied.." }
    redirect_to login_path, :i18n_key => exception.message, redirect_uri: request.url
  end


protected

  # Public caching will disable the csrf token, since that should not be
  # shared from user to user.
  def cache_publically
    expires_in 1.hour, public: true
    @disable_csrf_token = true
  end

  # Caching privately will be less agressive than public caching, since we can
  # allow csrf tokens, as long as the cache gets refreshed after each patch
  # request.
  def cache_privately
    expires_in 5.minutes
  end

  # In case we shouldn't cache at all
  def dont_cache
    expires_now
  end

  # Will trigger a 401 Access Denied exception. Optionally a `i18n_key`
  # parameter can be parsed, which is the i18n key to display as the flash
  # message.
  def access_denied i18n_key = 'application.access_denied'
    respond_to do |format|
      format.html do
        redirect_to login_path({ i18n_key: i18n_key, redirect_uri: request.url }) and return
      end
      format.any { raise 401 }
    end
  end

  def require_login
    access_denied unless logged_in?
  end

  def current_user
    @current_user ||= User.where(id_token: session[:id_token]).first
  end
  helper_method :current_user

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def get?
    request.get?
  end
end
