class ParseTimeRange < ApplicationService
  def initialize(year = nil, month = nil)
    @year = ParseYear.call(year)
    @month = ParseMonth.call(month)
  end

  def call
    case
    when year.present? && month.present?
      time = Time.new(year, month)
      time.beginning_of_month..time.end_of_month
    when year.present?
      time = Time.new(year)
      time.beginning_of_year..time.end_of_year
    else
      time = Time.now
      time.beginning_of_day..time.end_of_day
    end
  end

  private

  attr_reader :year, :month
end
