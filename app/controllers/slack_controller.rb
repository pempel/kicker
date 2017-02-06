class SlackController < ApplicationController
  post "/events" do
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
