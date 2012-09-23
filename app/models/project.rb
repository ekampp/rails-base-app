class Project
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :featured, type: Boolean
  field :finished_at, type: Time

  belongs_to :user

  validates :url, presence: true
end
