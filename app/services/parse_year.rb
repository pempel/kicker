class ParseYear < ApplicationService
  def initialize(year = nil)
    @year = year.to_s.to_i
  end

  def call
    year > 1970 ? year : nil
  end

  private

  attr_reader :year
end
