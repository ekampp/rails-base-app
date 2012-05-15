class CharacterObserver < Mongoid::Observer

  #
  # Observes the character creation, and sends a welcome mail to the
  # character's user
  #
  def after_create character
    CharacterMailer.created(character).deliver
  end

  #
  # After updating a character, a mail will be send, updating the user with
  # information that this has happened.
  #
  # TODO: Since we don't need to send mails to the user each time the energy is
  #       regerated or used, we should have some fine-grained filtering here,
  #       to identify the correct events that triggers an update mail.
  #       <emil@kampp.me>
  #
  def after_update
    # CharacterMailer.updated(@character).deliver if @character.changed? and @character.save
  end

end
