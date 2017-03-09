class SessionsController < ApplicationController
  get "/signout", auth: true do
    set_current_identity(nil)
    redirect "/"
  end

  get "/signin" do
    if settings.current_identity_mock.present?
      set_current_identity(settings.current_identity_mock)
      redirect team_path
    else
      redirect "/auth/slack"
    end
  end

  get "/auth/slack/callback" do
    info = request.env["omniauth.auth"].to_h["info"].to_h.deep_symbolize_keys
    identity = Identity.where(slack_id: info[:user_id]).first
    if identity.blank?
      identity = Identity.new
      identity.team = Team.new(slack_id: info[:team_id], name: info[:team])
      identity.user = User.new
      identity.slack_id = info[:user_id]
      identity.nickname = info[:nickname]
      identity.first_name = info[:first_name]
      identity.last_name = info[:last_name]
      identity.save!
    end
    if current_identity.present?
      if identity.user != current_identity.user
        identity_user_id = identity.user.id
        identity.user = current_identity.user
        identity.save && User.where(id: identity_user_id).delete
      end
    end
    set_current_identity(identity)
    redirect previous_path || team_path
  end
end
