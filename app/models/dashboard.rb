class Dashboard
  delegate :type, :teams, :team, :users, :user, :year, :month, to: :options

  def self.types
    %w[overview timeline]
  end

  def self.build(current_user, options = {})
    options = DashboardOptions.new(current_user, options)
    case options.type
    when "overview"
      if options.user.present?
        Dashboard::UserOverview.new(options)
      else
        Dashboard::TeamOverview.new(options)
      end
    end
  end

  def initialize(options)
    @options = options
  end

  def valid?
    options.valid?
  end

  def invalid?
    !valid?
  end

  def name
    @_name ||= self.class.name.demodulize.underscore
  end

  def filters
    @_filters ||= DashboardFilters.new(self)
  end

  def years
    @_years ||= active_years.first.downto(active_years.last).to_a
  end

  def months
    @_months ||= (1..12).to_a
  end

  def active_years
    @_active_years ||= timeline.map(&:year)
  end

  def active_months(year)
    timeline.find { |t| t.year == ParseYear.call(year) }.try(:months) || []
  end

  private

  attr_reader :options

  def timeline
    @_timeline ||= begin
      timeline = Hash.new.tap do |t|
        team.users.each do |user|
          user.feeds.each do |feed|
            feed.events.pluck(:created_at).each do |time|
              year, month = time.year, time.month
              t[year] = t.fetch(year, SortedSet.new).add(month)
            end
          end
        end
        now = Time.now
        year, month = now.year, now.month
        t[year] = t.fetch(year, SortedSet.new).add(month)
      end
      timeline.sort.reverse.map do |year, months|
        OpenStruct.new(year: year, months: months)
      end
    end
  end
end
