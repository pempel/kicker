FactoryGirl.define do
  factory :identity do
    association :user, strategy: :build
    sequence(:uid) { |n| "u#{n}" }
    sequence(:tid) { |n| "t#{n}" }
    nickname "nickname"
  end
end
