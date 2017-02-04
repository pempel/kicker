class User
  include Mongoid::Document

  field :slack_user_id, type: String
  field :slack_team_id, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :nickname, type: String

  validates :slack_user_id, presence: true
  validates :slack_team_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :nickname, presence: true
end
