class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    @user = User.find_or_initialize_by auth_hash
    logger.debug { "SESSION CONTROLLER: Identified user #{@user.inspect} from auth hash." }
    if @user.present? and @user.save
      logger.debug { "SESSION CONTROLLER: Logging in user #{@user.id}" }
      session[:user_id] = @user.id
      redirect_to get_stored_location
    else
      render :new
    end
  end

  def new
    if logged_in?
      redirect_to my_account_path
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

protected

  #
  # Returns the omniauth env hash
  #
  def auth_hash
    request.env['omniauth.auth'].with_indifferent_access
  end

end
