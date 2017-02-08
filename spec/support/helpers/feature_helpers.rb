module FeatureHelpers
  def app
    Proudly.new
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
