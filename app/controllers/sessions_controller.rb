class SessionsController < ApplicationController
  get "/signout", auth: true do
    set_current_identity(nil)
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
        identity_user_id = identity.user.id
        identity.user = current_identity.user
        identity.save && User.where(id: identity_user_id).delete
      end
    end
    set_current_identity(identity)
    redirect "/team"
  end
end
