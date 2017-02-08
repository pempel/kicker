module OmniAuthHelpers
  def mock_slack_auth_hash(hash = {})
    hash = hash.deep_symbolize_keys
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:slack] = {
      "provider" => "slack",
      "uid" => hash[:uid] || "U40XXX62X",
      "info" => {
        "nickname" => hash[:nickname] || "nickname",
        "team" => "Team",
        "user" => hash[:nickname] || "nickname",
        "team_id" => "T40XX9X66",
        "user_id" => hash[:uid] || "U40XXX62X",
        "first_name" => hash[:first_name] || "First Name",
        "last_name" => hash[:last_name] || "Last Name"
      }
    }
    if block_given?
      yield
      OmniAuth.config.mock_auth[:slack] = nil
    end
  end
end

RSpec.configure do |config|
  config.include OmniAuthHelpers, type: :feature
  config.before(:each, type: :feature) do
    OmniAuth.config.mock_auth[:slack] = nil
  end
end
