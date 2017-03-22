FactoryGirl.define do
  factory :team_rename_event_hash, class: Hash do
    transient do
      name "New Team Name"
    end

    token "token"
    team_id "T1"
    type "event_callback"
    event { {type: "team_rename", name: name} }

    initialize_with { attributes }
  end
end
