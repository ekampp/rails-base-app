class Admin::UsersController < InheritedResources::Base
  # Restricts access
  before_filter :require_login
  before_filter do
    require_role :admin
  end
  load_and_authorize_resource

  # Respond to js
  respond_to :json, only: [ :index ]

  def index
    index! do |format|
      format.json { render json: @users }
      format.html { render :index }
    end
  end

protected

  def resource
    @user = Admin::User.find(params[:id]) rescue nil
  end

  def collection
    if params[:search].present?
      @users = User.search(params[:search])
    else
      @users = User.all
      logger.debug("Users count: #{@users.count}. Ispection: #{@users.all.first.inspect}")
    end
  end

end
