FactoryGirl.define do
  factory :feed do
    association :identity, strategy: :build
    year Time.now.year
  end
end
