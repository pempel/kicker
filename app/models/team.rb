class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :users, dependent: :destroy
  embeds_one :settings, class_name: "TeamSettings", autobuild: true

  field :tid, type: String
  field :name, type: String

  validates :tid, presence: true, uniqueness: true
  validates :name, presence: true
end
