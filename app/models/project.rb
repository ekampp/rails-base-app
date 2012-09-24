class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name, type: String
  field :url, type: String
  field :description, type: String
  field :featured, type: Boolean, default: false
  field :finished_at, type: Time

  belongs_to :user

  validates :url, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates_inclusion_of :featured, presence: true, in: [ true, false ]
  validates :finished_at, presence: true
end
