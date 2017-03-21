module OmniAuthHelpers
  def as_slack_user(auth = {})
    auth = auth.deep_symbolize_keys
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:slack] = {
      "provider" => "slack",
      "uid" => auth[:uid] || "U1",
      "info" => {
        "nickname" => auth[:nickname] || "nickname",
        "team" => "Team 1",
        "user" => auth[:nickname] || "nickname",
        "team_id" => auth[:tid] || "T1",
        "user_id" => auth[:uid] || "U1",
        "first_name" => auth[:first_name] || "First Name",
        "last_name" => auth[:last_name] || "Last Name",
        "team_domain" => (auth[:team_domain] || auth[:tid] || "T1").downcase
      },
      "credentials" => {
        "token" => auth[:token] || "xoxp-1574-1575"
      }
    }
    yield
    OmniAuth.config.mock_auth[:slack] = nil
  end
end

RSpec.configure do |config|
  config.include OmniAuthHelpers, type: :feature
  config.before(:each, type: :feature) do
    OmniAuth.config.mock_auth[:slack] = nil
  end
end
