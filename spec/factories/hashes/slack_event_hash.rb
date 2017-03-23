FactoryGirl.define do
  factory :slack_event_hash, class: Hash do
    token "token"
    team_id "T1"
    type "event_callback"

    initialize_with { attributes }
  end
end
