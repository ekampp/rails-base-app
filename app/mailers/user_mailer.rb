class UserMailer < ActionMailer::Base
  default from: "do-not-reply@future-game.com"

  #
  # Sends a mail to the user, giving him a short overview of his options from
  # this point onwards.
  #
  def welcome user
    @user = user
    mail to: user.info[:email]
  end

  #
  # Sends the user an email, regreting that he canceled his account, and how to
  # come back and play.
  #
  def godbye user
    @user = user
    mail to: user.info[:email]
  end
end
