class DashboardOptions
  def initialize(current_user, options = {})
    @current_user = current_user
    @options = options.to_h.deep_symbolize_keys
  end

  def type
    @_type ||= options[:type].in?(Dashboard.types) ? options[:type] : ""
  end

  def teams
    @_teams ||= current_user.try(:identity).try(:users).map(&:team)
  end

  def team
    @_team ||= teams.find { |t| t.tid == options[:tid] }
  end

  def users
    @_users ||= team.present? ? team.users.to_a : []
  end

  def user
    @_user ||= users.find { |u| u.uid == options[:uid] }
  end

  def year
    @_year ||= ParseYear.call(options[:year])
  end

  def month
    @_month ||= ParseMonth.call(options[:month])
  end

  def valid?
    valid = type.present? && team.present? && year.present?
    valid = valid && user.present? if options[:uid].present?
    valid = valid && month.present? if options[:month].present?
    valid
  end

  private

  attr_reader :current_user, :options
end
