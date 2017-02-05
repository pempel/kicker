FactoryGirl.define do
  factory :identity do
    sequence(:uid) { |n| "u#{n}" }
    sequence(:tid) { |n| "t#{n}" }
    nickname "nickname"
    association :user, strategy: :build
  end
end
