class SlackController < ApplicationController
  post "/slack/events" do
    case params["type"]
    when "url_verification"
      headers "Content-Type" => "application/x-www-form-urlencoded"
      body params["challenge"]
    when "event_callback"
      HandleSlackEvent.call(params)
    end
  end

  post "/slack/commands/proud_of" do
    if params["command"] == "/proud_of"
      tid = params["team_id"]
      uid = params["user_id"]
      event_triggered_by = User.where(uid: uid).first || User.new.tap do |user|
        user.team = Team.where(tid: tid).first || Team.new(tid: tid)
        user.identity = Identity.new
        user.uid = params["user_id"]
        user.nickname = params["user_name"]
        user.save!
      end
      event = Event::WorkRecognized.new(triggered_by: event_triggered_by)
      uid, nickname = params["text"].scan(/<@([^|]*)\|([^>]*)>/).last.to_a
      user = User.where(uid: uid, nickname: nickname).first
      user ||= User.new.tap do |user|
        user.team = Team.where(tid: tid).first || Team.new(tid: tid)
        user.identity = Identity.new
        user.uid = uid
        user.nickname = nickname
        user.save!
      end
      user.feed.events << event
      body "You are proud of #{nickname}."
    end
  end
end
