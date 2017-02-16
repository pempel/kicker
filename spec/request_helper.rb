require "spec_helper"

module RequestHelpers
  def app
    Proudly.new
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RequestHelpers
end
