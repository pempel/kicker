class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :identities, dependent: :destroy

  field :slack_id, type: String
  field :name, type: String

  validates :slack_id, presence: true, uniqueness: true
  validates :name, presence: true
end
