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
    user = User::FindOrCreateByAuthHash.call(request.env["omniauth.auth"])
    if current_user && current_user.identity != user.identity
      user_identity_id = user.identity_id
      user.identity = current_user.identity
      user.save && Identity.where(id: user_identity_id).delete
    end
    set_current_user(user)
    redirect previous_path || team_path
  end
end
