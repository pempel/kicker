require "bundler/setup"
require "mongoid"
require "rack/csrf"
require "sinatra/base"
require "sinatra/reloader"
require "sinatra/content_for"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))

paths = [
  "app/validators/**/*.rb",
  "app/models/event.rb",
  "app/models/event/base.rb",
  "app/models/dashboard.rb",
  "app/models/**/*.rb",
  "app/services/application_service.rb",
  "app/services/**/*.rb",
  "app/helpers/**/*.rb",
  "app/conditions/**/*.rb",
  "app/controllers/application_controller.rb",
  "app/controllers/**/*.rb"
]

paths.each do |path|
  Dir[File.expand_path("../../#{path}", __FILE__)].each { |f| require f }
end

class Kicker
  attr_reader :app

  def initialize
    @app = Rack::Builder.app do
      use DashboardController
      use SessionsController
      use SettingsController
      use SlackController
      run WelcomeController
    end
  end

  def call(env)
    app.call(env)
  end
end
