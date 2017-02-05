require "bundler/setup"
require "mongoid"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

Dir[File.expand_path("../../app/models/**/*.rb", __FILE__)].each do |file|
  require file
end
