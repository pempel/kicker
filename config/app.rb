require "bundler"
Bundler.require(:default)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

Dir.glob("./models/*.rb").each { |f| require f }

require File.expand_path("../../app", __FILE__)
