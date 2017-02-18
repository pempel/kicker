FactoryGirl.define do
  factory :feed do
    association :identity, strategy: :build
    year Date.today.year
  end
end
