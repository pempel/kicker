FactoryGirl.define do
  factory :team_domain_change_event_hash, parent: :slack_event_hash do
    transient do
      domain "new-domain"
    end

    event do
      {
        type: "team_domain_change",
        domain: domain
      }
    end
  end
end
