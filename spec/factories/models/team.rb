FactoryGirl.define do
  factory :team do
    sequence(:tid) { |n| "T#{n}" }
    domain { tid.downcase }
    name "Name"
  end
end
