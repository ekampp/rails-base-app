class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Admins
    if user.role == "admin"
      can :manage, :all
    end

    # Players
    if user.role == "player"
      can :read, :all

      # Setting user model permissions
      can :create, User
      can :update, User, id: user.id
      can :destroy, User, id: user.id
    end
  end
end
