class TeamMembersPresenter
  def initialize(tid:, from: nil, to: nil)
    @tid = tid.to_s
    @from = from || Time.now.beginning_of_month
    @to = to || Time.now.end_of_month
  end

  def members
    @members ||= build_members.sort_by(&:points).reverse
  end

  private

  attr_reader :tid, :from, :to

  def build_members
    Identity.where(tid: tid).all.map do |identity|
      OpenStruct.new.tap do |member|
        member.points = calculate_points(identity)
        member.nickname = identity.nickname
        member.name = identity.name
      end
    end
  end

  def calculate_points(identity)
    identity.feed.events
      .where(_type: "Event::PointsEarned")
      .where(created_at: (from..to))
      .sum(:points)
  end
end
