class ApplicationController < Sinatra::Base
  helpers Sinatra::ContentFor
  helpers ApplicationHelpers

  register ApplicationConditions

  enable :sessions
  set :session_secret, ENV.fetch("SESSION_SECRET")
  set :public_folder, File.expand_path("../../../public", __FILE__)
  set :views, File.expand_path("../../views", __FILE__)
  set :current_fake_user, nil

  use Rack::MethodOverride
  use Rack::Csrf, skip: ["POST:/slack/events"]
  use OmniAuth::Builder do
    client_id = ENV.fetch("SLACK_CLIENT_ID")
    client_secret = ENV.fetch("SLACK_CLIENT_SECRET")
    client_options = {
      provider_ignores_state: true,
      scope: "reactions:read team:read users:read"
    }
    provider :slack, client_id, client_secret, client_options
  end

  before do
    if request.content_type == "application/json"
      request.body.rewind
      @params = JSON.parse(request.body.read.to_s)
    end
  end

  configure :development, :fake do
    register Sinatra::Reloader
  end

  configure :fake do
    set :current_fake_user, User.where(uid: "U1").first
  end
end
