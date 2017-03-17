module OmniAuthHelpers
  def as_slack_user(auth = {})
    auth = auth.deep_symbolize_keys
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:slack] = {
      "provider" => "slack",
      "uid" => auth[:uid] || "U40XXX62X",
      "info" => {
        "nickname" => auth[:nickname] || "nickname",
        "team" => "Team",
        "user" => auth[:nickname] || "nickname",
        "team_id" => "T40XX9X66",
        "user_id" => auth[:uid] || "U40XXX62X",
        "first_name" => auth[:first_name] || "First Name",
        "last_name" => auth[:last_name] || "Last Name"
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
