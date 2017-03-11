require "spec_helper"

module RequestHelpers
  def app
    Kicker.new
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RequestHelpers
end
