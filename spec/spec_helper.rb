ENV["RACK_ENV"] = "test"

require "simplecov"
require "coveralls"

if ENV["COVERALLS_REPO_TOKEN"]
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_filter "spec/"
end

require File.expand_path("../../config/application", __FILE__)

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Rack::Test::Methods
end
