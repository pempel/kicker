class SessionsController < ApplicationController
  get "/signout", auth: true do
    set_current_user(nil)
    redirect "/"
  end

  get "/signin" do
    if settings.current_fake_user.present?
      set_current_user(settings.current_fake_user)
      redirect team_path
    else
      redirect "/auth/slack"
    end
  end

  get "/auth/slack/callback" do
    auth = request.env["omniauth.auth"].to_h.deep_symbolize_keys
    info = auth[:info] || {}
    credentials = auth[:credentials] || {}
    user = User.where(uid: info[:user_id]).first
    if user.blank?
      user = User.new
      user.team = Team.new(tid: info[:team_id], name: info[:team])
      user.identity = Identity.new
      user.uid = info[:user_id]
      user.token = credentials[:token]
      user.nickname = info[:nickname]
      user.first_name = info[:first_name]
      user.last_name = info[:last_name]
      user.save!
    end
    if current_user.present?
      if user.identity != current_user.identity
        user_identity_id = user.identity_id
        user.identity = current_user.identity
        user.save && Identity.where(id: user_identity_id).delete
      end
    end
    set_current_user(user)
    redirect previous_path || team_path
  end
end
