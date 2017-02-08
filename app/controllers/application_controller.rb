class ApplicationController < Sinatra::Base
  helpers ApplicationHelpers
  register ApplicationConditions

  set :views, File.expand_path('../../views', __FILE__)

  enable :sessions

  use OmniAuth::Builder do
    client_id = ENV["SLACK_CLIENT_ID"]
    client_secret = ENV["SLACK_CLIENT_SECRET"]
    provider :slack, client_id, client_secret, scope: "commands,users:read"
  end

  configure :development do
    register Sinatra::Reloader
  end
end
