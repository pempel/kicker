class SlackController < ApplicationController
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
          identity.nickname = nickname
          identity.first_name = first_name
          identity.last_name = last_name
          identity.save!
        end
      end
    end
  end

  post "/slack/commands/proud_of" do
    if params["command"] == "/proud_of"
      tid = params["team_id"]
      uid = params["user_id"]
      event_triggered_by = Identity.where(tid: tid, uid: uid).first
      event_triggered_by ||= Identity.new.tap do |identity|
        identity.user = User.new
        identity.tid = tid
        identity.uid = params["user_id"]
        identity.nickname = params["user_name"]
        identity.save!
      end
      event = Event::WorkRecognized.new(triggered_by: event_triggered_by)
      uid, nickname = params["text"].scan(/<@([^|]*)\|([^>]*)>/).last.to_a
      identity = Identity.where(tid: tid, uid: uid, nickname: nickname).first
      identity ||= Identity.new.tap do |identity|
        identity.user = User.new
        identity.tid = tid
        identity.uid = uid
        identity.nickname = nickname
        identity.save!
      end
      identity.feed.events << event
      body "You are proud of #{nickname}."
    end
  end
end
