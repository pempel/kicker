class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: String
  field :tid, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  belongs_to :user
  has_many :feeds

  validates :uid, presence: true
  validates :tid, presence: true
  validates :nickname, presence: true

  def feed
    feeds.where(year: Date.today.year).first
  end
end
