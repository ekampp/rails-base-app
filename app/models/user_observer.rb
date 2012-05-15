class UserObserver < Mongoid::Observer
   observe :user

  #
  # Observes user creation.
  #
  # This will do the following things when a user is created:
  #   * Send a welcome mail
  #
  def after_create user
    UserMailer.welcome(user).deliver
  end

  #
  # Observes the user canceling his account.
  #
  # This will
  #   * send a mail, trying to bring the user back
  #
  def after_destroy user
    UserMailer.godbye(user).deliver
  end

end
