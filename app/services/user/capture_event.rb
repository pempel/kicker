class User::CaptureEvent < ApplicationService
  def initialize(user, triggered_at: nil, **event_params)
    @user = user
    @triggered_at = triggered_at
    @event_params = event_params
  end

  def call
    event = Event::WorkRecognized.new(event_params)
    event_created_at = event.created_at || Time.now

    unless event.valid?
      raise StandardError.new("ERROR")
    end

    feed = user.feeds.where(year: event_created_at.year).first
    feed ||= Feed.new.tap do |feed|
      feed.user = user
      feed.year = event_created_at.year
      feed.created_at = event_created_at
      feed.updated_at = event_created_at
      feed.save!
    end

    feed.events << event

    true
  end

  private

  attr_reader :user, :triggered_at

  def event_params
    @_event_params ||= begin
      params = @event_params.to_h.deep_symbolize_keys
      params.merge!(created_at: triggered_at) if triggered_at.present?
      params.merge!(updated_at: triggered_at) if triggered_at.present?
      params
    end
  end
end
