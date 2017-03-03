class ParseYearAndMonth < ApplicationService
  def initialize(year = nil, month = nil)
    @year = year
    @month = month
    @changed = false
    @now = Time.now
  end

  def call
    [year, month, changed]
  end

  private

  attr_reader :changed

  def year
    @_year ||= begin
      if @year.to_i > 1970
        @year.to_i
      else
        @changed = true
        @now.year
      end
    end
  end

  def month
    @_month ||= begin
      if @month.present?
        if @month.to_i.between?(1, 12)
          @month.to_i
        else
          @changed = true
          @now.month
        end
      end
    end
  end
end
