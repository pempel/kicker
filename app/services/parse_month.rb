class ParseMonth < ApplicationService
  def initialize(month = nil)
    @month = month.to_s.to_i
  end

  def call
    month.between?(1, 12) ? month : nil
  end

  private

  attr_reader :month
end
