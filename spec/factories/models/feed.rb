FactoryGirl.define do
  factory :feed do
    association :user, strategy: :build
    year Time.now.year
  end
end
