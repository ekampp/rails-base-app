class UsersController < InheritedResources::Base
  before_filter :require_login
  load_and_authorize_resource

  #
  # Updates the given user with the putted +user+ params.
  # A user should not be allowed to update any other profile than his own,
  # unless he can manage the user model.
  #
  def update
    update! do |format|
      format.html do
        respond_with resource, location: my_account_path
      end
    end
  end

  #
  # Destroys the user
  # Any user can destroy their own profile, but only admins can destroy other
  # users profiles.
  #
  def destroy
    destroy! do |format|
      format.html do
        respond_with resource, location: root_path
      end
    end
  end

protected

  def resource
    @user = current_user
  end

end
