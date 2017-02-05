class Proudly < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  use OmniAuth::Builder do
    client_id = ENV["SLACK_CLIENT_ID"]
    client_secret = ENV["SLACK_CLIENT_SECRET"]
    provider :slack, client_id, client_secret, scope: "commands,users:read"
  end

  helpers do
    def current_identity
      @current_identity ||= Identity.where(id: session[:identity_id]).first
    end

    def current_identity=(identity)
      @current_identity = identity
      session[:identity_id] = identity.try(:id).try(:to_s)
    end
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

  get "/signin" do
    redirect "/auth/slack"
  end

  get "/signout" do
    current_identity = nil
    redirect "/"
  end

  get "/" do
    slim :index
  end

  get "/app" do
    current_identity.present? ? redirect("/") : slim(:application)
  end

  post "/slack/events" do
    hash = JSON.parse(request.body.read.to_s)
    case hash["type"]
    when "url_verification"
      headers "Content-Type" => "application/x-www-form-urlencoded"
      body hash["challenge"]
    when "event_callback"
      event_hash = hash.fetch("event", {})
      event_type = event_hash["type"]

      user_hash = event_hash.fetch("user", {})
      user_profile_hash = user_hash.fetch("profile", {})

      uid = user_hash["id"]
      nickname = user_hash["name"]
      first_name = user_profile_hash["first_name"]
      last_name = user_profile_hash["last_name"]

      if event_type == "user_change"
        identity = Identity.where(uid: uid).first
        if identity.present?
          identity.nickname = nickname if nickname.present?
          identity.first_name = first_name if first_name.present?
          identity.last_name = last_name if last_name.present?
          identity.save!
        end
      end
    end
  end
end
