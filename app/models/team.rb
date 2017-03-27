class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :users, dependent: :destroy

  field :tid, type: String
  field :domain, type: String
  field :name, type: String
  field :reaction_points, type: Integer, default: 1
  field :github_integration_enabled, type: Boolean, default: false
  field :github_repositories, type: Array, default: []

  validates :tid, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true
  validates :name, presence: true

  def reaction_emoji
    (emoji = ENV["REACTION_EMOJI"]).present? ? emoji : "+1"
  end

  def reaction_emoji_unicode
    Emoji.find_by_alias(reaction_emoji).try(:raw) || "[EMOJI NOT FOUND]"
  end
end
