class Feed
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :identity
  embeds_many :events, as: :eventable, class_name: "Event::Base"

  field :year, type: Integer

  validates :year, presence: true, uniqueness: {scope: :identity_id}
end
