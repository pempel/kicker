class ApplicationController < Sinatra::Base
  helpers ApplicationHelpers
  register ApplicationConditions

  set :views, File.expand_path("../../views", __FILE__)
  set :public_folder, File.expand_path("../../../public", __FILE__)

  enable :sessions

  use OmniAuth::Builder do
    client_id = ENV["SLACK_CLIENT_ID"]
    client_secret = ENV["SLACK_CLIENT_SECRET"]
    provider :slack, client_id, client_secret, scope: "commands,users:read"
  end

  before do
    if request.content_type == "application/json"
      request.body.rewind
      @params = JSON.parse(request.body.read.to_s)
    end
    @params = params.deep_symbolize_keys
  end

  configure do
    set :current_identity_mock, nil
  end

  configure :development do
    register Sinatra::Reloader
  end

  configure :fake do
    set :current_identity_mock, Identity.where(slack_id: "U1").first
  end
end
