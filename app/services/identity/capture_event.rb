class Identity::CaptureEvent < ApplicationService
  def initialize(identity, triggered_at: nil, **event_params)
    @identity = identity
    @triggered_at = triggered_at
    @event_params = event_params
  end

  def call
    event = Event::WorkRecognized.new(event_params)
    event_created_at = event.created_at || Time.now

    unless event.valid?
      raise StandardError.new("ERROR")
    end

    feed = identity.feeds.where(year: event_created_at.year).first
    feed ||= Feed.new.tap do |f|
      f.identity = identity
      f.year = event_created_at.year
      f.created_at = event_created_at
      f.updated_at = event_created_at
      f.save!
    end

    feed.events << event

    true
  end

  private

  attr_reader :identity, :triggered_at

  def event_params
    @_event_params ||= begin
      params = @event_params.to_h.deep_symbolize_keys
      params.merge!(created_at: triggered_at) if triggered_at.present?
      params.merge!(updated_at: triggered_at) if triggered_at.present?
      params
    end
  end
end
