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
      slack_id = user_params[:id]
      nickname = user_params[:name]
      first_name = user_profile_params[:first_name]
      last_name = user_profile_params[:last_name]

      if event_type == "user_change"
        identity = Identity.where(slack_id: slack_id).first
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
    if params[:command] == "/proud_of"
      tid = params[:team_id]
      uid = params[:user_id]
      event_triggered_by = Identity.where(slack_id: uid).first
      event_triggered_by ||= Identity.new.tap do |identity|
        identity.team = Team.where(slack_id: tid).first
        identity.team ||= Team.new(slack_id: tid)
        identity.user = User.new
        identity.slack_id = params[:user_id]
        identity.nickname = params[:user_name]
        identity.save!
      end
      event = Event::WorkRecognized.new(triggered_by: event_triggered_by)
      uid, nickname = params[:text].scan(/<@([^|]*)\|([^>]*)>/).last.to_a
      identity = Identity.where(slack_id: uid, nickname: nickname).first
      identity ||= Identity.new.tap do |identity|
        identity.team = Team.where(slack_id: tid).first
        identity.team ||= Team.new(slack_id: tid)
        identity.user = User.new
        identity.slack_id = uid
        identity.nickname = nickname
        identity.save!
      end
      identity.feed.events << event
      body "You are proud of #{nickname}."
    end
  end
end
