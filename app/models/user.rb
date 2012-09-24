class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :oauth_token, type: String
  field :oauth_expires_at, type: Time
  field :id_token, type: String, default: rand(36**8).to_s(36)
  field :locale, type: String, default: "da"
  field :admin, type: Boolean, default: false

  # Fetch the user based on the omniauth hash
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      auth.uid = auth.info.name if auth.uid.nil? and Rails.env.development?
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
      user.save!
    end
  end

  # Assigns rollout permissions and groups to the user
  #
  # NOTE: `$rollout` is defined in config/initializers/rollout.rb
  #
  def assign_rollout_permissions
    $rollout.activate_user(:direct_contact_options, self) if admin?
  end
end
