class TeamReportPresenter
  def initialize(team)
    @team = team
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
    team.users.map { |u| member(u, year, month) }.sort_by(&:points).reverse
  end

  private

  attr_reader :team

  def timeline
    @_timeline ||= begin
      timeline = Hash.new.tap do |timeline|
        team.users.each do |user|
          user.feeds.each do |feed|
            feed.events.pluck(:created_at).each do |time|
              year, month = time.year, time.month
              timeline[year] = timeline.fetch(year, SortedSet.new).add(month)
            end
          end
        end
        now = Time.now
        year, month = now.year, now.month
        timeline[year] = timeline.fetch(year, SortedSet.new).add(month)
      end
      timeline.sort.reverse.map do |year, months|
        OpenStruct.new(year: year, months: months)
      end
    end
  end

  def member(user, year, month = nil)
    OpenStruct.new.tap do |member|
      member.points = begin
        time_range = ParseTimeRange.call(year, month)
        feed = user.feeds.where(year: year).first
        if feed.blank?
          0
        else
          feed.events
            .where(_type: "Event::WorkRecognized")
            .where(created_at: time_range)
            .sum(:points)
        end
      end
      member.nickname = user.nickname
      member.name = user.name.present? ? user.name : "&mdash;".html_safe
    end
  end
end
