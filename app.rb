class ProudlyApp < Sinatra::Base
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
    def current_user
      @current_user ||= User.where(id: session[:user_id]).first
    end
  end

  get "/auth/slack/callback" do
    auth = request.env["omniauth.auth"]
    user = User.where(slack_user_id: auth["info"]["user_id"]).first
    if user.nil?
      user = User.new
      user.slack_user_id = auth["info"]["user_id"]
      user.slack_team_id = auth["info"]["team_id"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.nickname = auth["info"]["nickname"]
      user.save!
    end
    session[:user_id] = user.id.to_s
    redirect "/app"
  end

  get "/signin" do
    redirect "/auth/slack"
  end

  get "/signout" do
    session[:user_id] = nil
    redirect "/"
  end

  get "/" do
    slim :index
  end

  get "/app" do
    if current_user.nil?
      redirect "/"
    else
      slim :app
    end
  end

  post "/events" do
    hash = JSON.parse(request.body.read.to_s).deep_symbolize_keys
    case hash[:type]
    when "url_verification"
      headers "Content-Type" => "application/x-www-form-urlencoded"
      body hash[:challenge]
    when "event_callback"
      event_hash = hash.fetch(:event, {})
      event_type = event_hash[:type]

      user_hash = event_hash.fetch(:user, {})
      user_id = user_hash[:id]
      user_nickname = user_hash[:name]

      profile_hash = user_hash.fetch(:profile, {})
      user_first_name = profile_hash[:first_name]
      user_last_name = profile_hash[:last_name]

      if event_type == "user_change"
        user = User.where(slack_user_id: user_id).first
        if user.present?
          user.first_name = user_first_name if user_first_name.present?
          user.last_name = user_last_name if user_last_name.present?
          user.nickname = user_nickname if user_nickname.present?
          user.save!
        end
      end
    end
  end
end
