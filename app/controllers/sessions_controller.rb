class SessionsController < ApplicationController
  get "/signout", auth: true do
    set_current_user(nil)
    redirect to("/")
  end

  get "/signin" do
    user = settings.current_fake_user
    if user.present?
      set_current_user(user)
      redirect to(main_dashboard_path)
    else
      redirect to("/auth/slack")
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
    redirect to(previous_path || main_dashboard_path)
  end
end
