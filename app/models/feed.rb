class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  field :year, type: Integer

  belongs_to :identity
  embeds_many :events, as: :eventable, class_name: "Event::Base"

  validates :year, presence: true, uniqueness: {scope: :identity_id}
end
