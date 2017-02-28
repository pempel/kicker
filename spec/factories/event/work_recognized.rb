FactoryGirl.define do
  factory :work_recognized, class: Event::WorkRecognized do
    association :eventable, factory: :feed, strategy: :build
    association :triggered_by, factory: :identity, strategy: :build
  end
end
