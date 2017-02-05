class Identity
  include Mongoid::Document

  field :uid, type: String
  field :tid, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  belongs_to :user

  validates :uid, presence: true
  validates :tid, presence: true
  validates :nickname, presence: true
end
