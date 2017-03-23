FactoryGirl.define do
  factory :user_change_event_hash, parent: :slack_event_hash do
    transient do
      uid "U1"
      nickname "new-nickname"
      name "NewFirstName NewLastName"
    end

    event do
      {
        type: "user_change",
        user: {
          id: uid,
          name: nickname,
          profile: {
            first_name: name.split(" ")[0].to_s,
            last_name: name.split(" ")[1].to_s
          }
        }
      }
    end
  end
end
