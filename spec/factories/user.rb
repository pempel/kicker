FactoryGirl.define do
  factory :user do
    association :team, strategy: :build
    sequence(:uid) { |n| "U#{n}" }
    nickname "nickname"
  end
end
