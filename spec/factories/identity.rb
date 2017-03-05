FactoryGirl.define do
  factory :identity do
    association :team, strategy: :build
    sequence(:slack_id) { |n| "U#{n}" }
    nickname "nickname"
  end
end
