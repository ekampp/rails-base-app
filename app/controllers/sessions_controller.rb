class SessionsController < ApplicationController
  class NoUserFound < StandardError; end;

  # Filters
  before_filter :dont_cache

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    raise NoUserFound unless user.present? and user.is_a?(User)
    session[:id_token] = user.id_token
    cookies[:_logged_in] = Time.zone.now
    @current_user = user
    redirect_to admin_path
  end

  def destroy
    session.delete :id_token
    cookies.delete :_logged_in
    redirect_to root_path
  end

  def new
    params[:redirect_uri] ||= admin_path
  end
end
