class TeamReportPresenter
  def initialize(tid)
    @tid = tid.to_s
  end

  def label(year, month = nil)
    Time.new(year, month).strftime(month.present? ? "%b" : "%Y") rescue year
  end

  def years
    active_years.first.downto(active_years.last).to_a
  end

  def months
    (1..12).to_a
  end

  def active_years
    timeline.map(&:year)
  end

  def active_months(year)
    timeline.find { |t| t.year == year }.try(:months) || []
  end

  def members(year, month = nil)
    identities.map { |i| member(i, year, month) }.sort_by(&:points).reverse
  end

  private

  attr_reader :tid

  def identities
    @_identities ||= Identity.where(tid: tid).all
  end

  def timeline
    @_timeline ||= begin
      timeline = Hash.new.tap do |hash|
        identities.each do |identity|
          identity.feeds.each do |feed|
            feed.events.pluck(:created_at).each do |time|
              year, month = time.year, time.month
              hash[year] = hash.fetch(year, SortedSet.new).add(month)
            end
          end
        end
        now = Time.now
        year, month = now.year, now.month
        hash[year] = hash.fetch(year, SortedSet.new).add(month)
      end
      timeline.sort.reverse.map do |year, months|
        OpenStruct.new(year: year, months: months)
      end
    end
  end

  def member(identity, year, month = nil)
    OpenStruct.new.tap do |member|
      member.points = begin
        time_range = ParseTimeRange.call(year, month)
        feed = identity.feeds.where(year: year).first
        if feed.blank?
          0
        else
          feed.events
            .where(_type: "Event::WorkRecognized")
            .where(created_at: time_range)
            .sum(:points)
        end
      end
      member.nickname = identity.nickname
      member.name = identity.name.present? ? identity.name : "&mdash;".html_safe
    end
  end
end
