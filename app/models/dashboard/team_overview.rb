class Dashboard::TeamOverview < Dashboard
  Member = Struct.new(:points, :nickname, :name)

  def members
    users.map { |u| build_member(u) }.sort_by(&:points).reverse
  end

  private

  def timerange
    @_timerange ||= ParseTimeRange.call(year, month)
  end

  def build_member(user)
    Member.new(calculate_points(user), user.nickname, user.name)
  end

  def calculate_points(user)
    feed = user.feeds.where(year: timerange.first.year).first
    if feed.blank?
      0
    else
      feed.events
        .where(_type: "Event::WorkRecognized")
        .where(created_at: timerange)
        .sum(:points)
    end
  end
end
