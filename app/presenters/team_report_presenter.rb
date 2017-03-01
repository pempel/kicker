class TeamReportPresenter
  attr_reader :tid, :from, :to

  def initialize(tid:, from: nil, to: nil)
    @tid = tid.to_s
    @from = from || Time.now.beginning_of_month
    @to = to || Time.now.end_of_month
  end

  def members
    @members ||= build_members.sort_by(&:points).reverse
  end

  private

  def build_members
    Identity.where(tid: tid).all.map { |i| build_member(i) }
  end

  def build_member(identity)
    points = begin
      identity.feed.events
        .where(_type: "Event::WorkRecognized")
        .where(created_at: (from..to))
        .sum(:points)
    end
    OpenStruct.new.tap do |member|
      member.points = points
      member.nickname = identity.nickname
      member.name = identity.name.present? ? identity.name : "&mdash;".html_safe
    end
  end
end
