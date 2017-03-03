class ParseTimeRange < ApplicationService
  def initialize(year = nil, month = nil)
    @year, @month = ParseYearAndMonth.call(year, month)
  end

  def call
    if month.present?
      time = Time.new(year, month)
      time.beginning_of_month..time.end_of_month
    else
      time = Time.new(year)
      time.beginning_of_year..time.end_of_year
    end
  end

  private

  attr_reader :year, :month
end
