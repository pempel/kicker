FactoryGirl.define do
  factory :points_earned, class: Event::PointsEarned do
    association :eventable, factory: :feed, strategy: :build
    association :triggered_by, factory: :identity, strategy: :build
  end
end
