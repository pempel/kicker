class DashboardFilters
  Filter = Struct.new(:text, :name, :value, :param, :selected, :disabled)

  def initialize(dashboard)
    @dashboard = dashboard
  end

  def by_types
    @_by_types ||= begin
      Dashboard.types.map do |type|
        Filter.new.tap do |f|
          f.text = type.capitalize
          f.name = "type"
          f.value = type
          f.param = {type: type}
          f.selected = type == dashboard.type
          f.disabled = false
        end
      end
    end
  end

  def by_teams
    @_by_teams ||= begin
      dashboard.teams.map do |team|
        Filter.new.tap do |f|
          f.text = team.name
          f.name = "tid"
          f.value = team.tid
          f.param = {tid: team.tid}
          f.selected = team.tid == dashboard.team.try(:tid)
          f.disabled = false
        end
      end
    end
  end

  def by_users
    @_by_users ||= begin
      filters = dashboard.users.map do |user|
        Filter.new.tap do |f|
          f.text = user.nickname
          f.name = "uid"
          f.value = user.uid
          f.param = {uid: user.uid}
          f.selected = user.uid == dashboard.user.try(:uid)
          f.disabled = false
        end
      end
      if dashboard.type == "overview"
        filter = Filter.new.tap do |f|
          f.text = "all members"
          f.name = "uid"
          f.value = nil
          f.param = {uid: nil}
          f.selected = dashboard.user.blank?
          f.disabled = false
        end
        filters.unshift(filter)
      end
      filters
    end
  end

  def by_years
    @_by_years ||= begin
      dashboard.years.map do |year|
        Filter.new.tap do |f|
          f.text = Time.new(year).strftime("%Y")
          f.name = "year"
          f.value = year
          f.param = {year: year, month: nil}
          f.selected = year == dashboard.year
          f.disabled = dashboard.active_years.exclude?(year)
        end
      end
    end
  end

  def by_months
    @_by_months ||= begin
      year = dashboard.year
      filters = dashboard.months.map do |month|
        Filter.new.tap do |f|
          f.text = year.present? ? Time.new(year, month).strftime("%b") : ""
          f.name = "month"
          f.value = month
          f.param = {month: month}
          f.selected = month == dashboard.month
          f.disabled = dashboard.active_months(year).exclude?(month)
        end
      end
      if dashboard.type == "overview"
        filter = Filter.new.tap do |f|
          f.text = "all months"
          f.name = "month"
          f.value = nil
          f.param = {month: nil}
          f.selected = dashboard.month.blank?
          f.disabled = false
        end
        filters.unshift(filter)
      end
      filters
    end
  end

  private

  attr_reader :dashboard
end
