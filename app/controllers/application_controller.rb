require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  #
  # Checks if a user is logged in
  #
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  #
  # Returns the currently logged in user based on a session stored on his
  # computer.
  #
  # This will check, if the user is enabled (e.g. not banned) before returning.
  #
  def current_user
    @current_user ||= User.find(session[:user_id]) rescue nil if session[:user_id].present?
    @current_user = nil unless @current_user.present? and @current_user.enabled?
    @current_user
  end
  helper_method :current_user

  #
  # Stores the current location
  #
  # Options
  #   * +force+ will force the current location as the stored one.
  #
  def store_location location = nil
    session[:stored_location] = location || request.fullpath
  end

  #
  # Gets the stored location.
  # If there is no stored location, this will default to (1) the
  # +my_account_path+ or (2) the +root_path+.
  #
  def get_stored_location
    loc = session[:stored_location]
    loc ||= my_account_path if logged_in?
    loc ||= root_path
    loc
  end

  #
  # Ensures that the user is logged in before proceeding.
  # This should be used as a before filter, to ensure that the content is only
  # visible to users that are logged in.
  #
  # Examples:
  #
  #   * before_filter :require_login
  #
  def require_login
    access_denied and return unless logged_in?
  end

  #
  # Requites the user to have the given `role` to access
  #
  def require_role role
    role = role.to_s unless role.is_a?(String)
    access_denied and return unless logged_in? and current_user.role == role
  end


  #
  # Redirects the user to the login page, and displays a message explaining the
  # reason for the login.
  #
  def access_denied msg = "login_required"
    store_location
    redirect_to login_path(msg: msg) and return
  end

  #
  # Logs the users access to this url
  #
  def log_access!
    current_user.accesses.create({
      ip: request.ip,
      url: request.url
    })
  end
end
