class ProudlyApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions

  use OmniAuth::Builder do
    client_id = ENV["SLACK_CLIENT_ID"]
    client_secret = ENV["SLACK_CLIENT_SECRET"]
    provider :slack, client_id, client_secret, scope: "commands"
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
end
