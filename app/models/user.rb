class User
  include Mongoid::Document
  include Mongoid::Paranoia # TODO: Make a cronjob to periodically scrub users
                            #       marked for deletion. <emil@kampp.me>

  # Field definitions
  field :role, type: String, :default => "user"
  field :provider, type: String
  field :uid, type: String
  field :info, type: Hash
  field :banned, type: Boolean, default: false

  # Indexes
  index :provider
  index :role

  # Validations
  # validates :uid, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :role, inclusion: { in: Proc.new{ possible_roles } }

  #
  # Will return an array of possible roles, that a user can have
  #
  def self.possible_roles
    [ "user", "admin" ]
  end

end
