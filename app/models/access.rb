class Access
  include Mongoid::Document
  include Mongoid::Timestamps

  # Relations
  belongs_to :user

  # Scopes
  scope :chronological, order_by("created_at asc")
end
