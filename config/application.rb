require "bundler/setup"
require "mongoid"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

path = "../../app/{models,helpers,controllers}/**/*.rb"
Dir[File.expand_path(path, __FILE__)].each { |f| require f }

class Proudly
  attr_reader :app

  def initialize
    @app = Rack::Builder.app do
      map("/") { run ApplicationController }
      map("/slack") { run SlackController }
    end
  end

  def call(env)
    app.call(env)
  end
end
