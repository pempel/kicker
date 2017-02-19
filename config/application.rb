require "bundler/setup"
require "mongoid"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

entities = "{validators,models,presenters,helpers,conditions,controllers}"
path = "../../app/#{entities}/**/*.rb"
Dir[File.expand_path(path, __FILE__)].each { |f| require f }

class Proudly
  attr_reader :app

  def initialize
    @app = Rack::Builder.app do
      use SessionsController
      use SlackController
      use TeamsController
      run WelcomeController
    end
  end

  def call(env)
    app.call(env)
  end
end
