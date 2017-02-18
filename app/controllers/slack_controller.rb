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
          identity.nickname = nickname if nickname.present?
          identity.first_name = first_name if first_name.present?
          identity.last_name = last_name if last_name.present?
          identity.save!
        end
      end
    end
  end

  post "/slack/commands/proud_of" do
    hash = JSON.parse(request.body.read.to_s)
    if hash["command"] == "/proud_of"
      tid = hash["team_id"]
      event_triggered_by = Identity.where(tid: tid, uid: hash["user_id"]).first
      event_triggered_by ||= Identity.new.tap do |i|
        i.user = User.new
        i.tid = tid
        i.uid = hash["user_id"]
        i.nickname = hash["user_name"]
        i.save!
      end
      event = Event::PointsEarned.new(triggered_by: event_triggered_by)
      uid, nickname = hash["text"].scan(/<@([^|]*)\|([^>]*)>/).last.to_a
      identity = Identity.where(tid: tid, uid: uid, nickname: nickname).first
      identity ||= Identity.new.tap do |i|
        i.user = User.new
        i.tid = tid
        i.uid = uid
        i.nickname = nickname
        i.save!
      end
      identity.feed.events << event
      body ""
    end
  end
end
