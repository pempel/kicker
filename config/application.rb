require "bundler/setup"
require "mongoid"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

paths = [
  "app/validators/**/*.rb",
  "app/models/event.rb",
  "app/models/event/base.rb",
  "app/models/**/*.rb",
  "app/presenters/**/*.rb",
  "app/helpers/**/*.rb",
  "app/conditions/**/*.rb",
  "app/controllers/application_controller.rb",
  "app/controllers/**/*.rb"
]

paths.each do |path|
  Dir[File.expand_path("../../#{path}", __FILE__)].each { |f| require f }
end

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
