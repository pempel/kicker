FactoryGirl.define do
  factory :team do
    sequence(:slack_id) { |n| "T#{n}" }
    name "Name"
  end
end
