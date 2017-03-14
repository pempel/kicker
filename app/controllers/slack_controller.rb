class SlackController < ApplicationController
  post "/slack/events" do
    case params[:type]
    when "url_verification"
      headers "Content-Type" => "application/x-www-form-urlencoded"
      body params[:challenge]
    when "event_callback"
      event_params = params.fetch(:event, {})
      user_params = event_params.fetch(:user, {})
      user_profile_params = user_params.fetch(:profile, {})

      event_type = event_params[:type]
      uid = user_params[:id]
      nickname = user_params[:name]
      first_name = user_profile_params[:first_name]
      last_name = user_profile_params[:last_name]

      if event_type == "user_change"
        user = User.where(uid: uid).first
        if user.present?
          user.nickname = nickname
          user.first_name = first_name
          user.last_name = last_name
          user.save!
        end
      end
    end
  end

  post "/slack/commands/proud_of" do
    if params[:command] == "/proud_of"
      tid = params[:team_id]
      uid = params[:user_id]
      event_triggered_by = User.where(uid: uid).first || User.new.tap do |user|
        user.team = Team.where(tid: tid).first || Team.new(tid: tid)
        user.identity = Identity.new
        user.uid = params[:user_id]
        user.nickname = params[:user_name]
        user.save!
      end
      event = Event::WorkRecognized.new(triggered_by: event_triggered_by)
      uid, nickname = params[:text].scan(/<@([^|]*)\|([^>]*)>/).last.to_a
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
