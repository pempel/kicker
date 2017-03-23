FactoryGirl.define do
  factory :team_rename_event_hash, parent: :slack_event_hash do
    transient do
      name "New Name"
    end

    event do
      {
        type: "team_rename",
        name: name
      }
    end
  end
end
