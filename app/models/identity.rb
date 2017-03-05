class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :team
  belongs_to :user, autobuild: true
  has_many :feeds, autosave: true, dependent: :destroy

  field :slack_id, type: String
  field :nickname, type: String
  field :first_name, type: String
  field :last_name, type: String

  validates :slack_id, presence: true, uniqueness: true
  validates :nickname, presence: true

  after_initialize :build_feed, if: :new_record?

  def feed
    feeds.to_a.find { |f| f.year == Time.now.year }
  end

  def name
    [first_name, last_name].join(" ").strip
  end

  private

  def build_feed
    feeds.build(year: Time.now.year)
  end
end
