FactoryGirl.define do
  factory :user do
    sequence(:slack_user_id) { |n| "slack_user_id_#{n}" }
    sequence(:slack_team_id) { |n| "slack_team_id_#{n}" }
    first_name "First Name"
    last_name "Last Name"
    nickname "nickname"
  end
end
