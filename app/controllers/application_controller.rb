class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

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

  get "/signout" do
    current_identity = nil
    redirect "/"
  end

  get "/signin" do
    redirect "/auth/slack"
  end

  get "/auth/slack/callback" do
    auth = request.env["omniauth.auth"]
    identity = Identity.where(uid: auth["info"]["user_id"]).first
    if identity.blank?
      identity = Identity.new
      identity.user = User.new
      identity.uid = auth["info"]["user_id"]
      identity.tid = auth["info"]["team_id"]
      identity.nickname = auth["info"]["nickname"]
      identity.first_name = auth["info"]["first_name"]
      identity.last_name = auth["info"]["last_name"]
      identity.save!
    end
    if current_identity.present?
      if identity.user != current_identity.user
        user = identity.user
        identity.user = current_identity.user
        identity.save && user.destroy
      end
    end
    current_identity = identity
    redirect "/app"
  end

  get "/" do
    slim :welcome
  end

  get "/app" do
    current_identity.present? ? redirect("/") : slim(:application)
  end
end
