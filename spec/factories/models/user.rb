FactoryGirl.define do
  factory :user do
    transient do
      name ""
    end

    association :team, strategy: :build
    sequence(:uid) { |n| "U#{n}" }
    token "token"
    nickname "nickname"

    after(:build) do |user, evaluator|
      name = evaluator.name.to_s
      if name.present?
        first_name, last_name = name.split(" ")
        user.first_name = first_name
        user.last_name = last_name
      end
    end
  end
end
