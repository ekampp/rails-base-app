module SessionsHelper

  #
  # Returns a translated representation of the +msg+ parameter grabbed from the
  # url, on the login page. This could, fx. be +msg=login_required+ and this
  # method will translate that within the correct scope. If nothing is
  # supplied, it will default as if the +msg+ was +login_required+.
  #
  def get_login_message_translation msg = "login_required"
    msg = I18n.translate("sessions.login_messages.#{msg}")
    msg if msg.is_a? String
  end

end
