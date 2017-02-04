require "bundler/setup"
require "mongoid"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

Dir.glob("./models/*.rb").each { |f| require f }

require "./app"
