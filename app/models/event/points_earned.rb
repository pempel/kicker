module Event
  class PointsEarned < Base
    field :points, type: Integer, default: 1

    belongs_to :triggered_by, class_name: "Identity"

    validates :points, positive_integer_number: true, presence: true
  end
end