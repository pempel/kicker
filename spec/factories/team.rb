FactoryGirl.define do
  factory :team do
    sequence(:tid) { |n| "T#{n}" }
    name "Name"
  end
end
