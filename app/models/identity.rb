class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: String
  field :tid, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  belongs_to :user
  has_many :feeds, autosave: true, dependent: :destroy

  validates :uid, presence: true
  validates :tid, presence: true
  validates :nickname, presence: true

  after_initialize :build_feed, if: :new_record?

  def feed
    feeds.to_a.find { |f| f.year == Date.today.year }
  end

  private

  def build_feed
    feeds.build(year: Date.today.year)
  end
end
