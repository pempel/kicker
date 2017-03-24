class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :users, dependent: :destroy

  field :tid, type: String
  field :domain, type: String
  field :name, type: String
  field :points_for_work_recognized_event, type: Integer, default: 1
  field :github_integration_enabled, type: Boolean, default: false
  field :github_repositories, type: Array, default: []

  validates :tid, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true
  validates :name, presence: true
end
