class User
  include Mongoid::Document

  field :slack_user_id, type: String
  field :slack_team_id, type: String
  field :nickname, type: String

  validates :slack_user_id, presence: true
  validates :slack_team_id, presence: true
  validates :nickname, presence: true
end
