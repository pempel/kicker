desc "Load the RACK_ENV environment"
task :environment do
  require "./config/application"
end

namespace :environment do
  desc "Load the test environment"
  task :test do
    ENV["RACK_ENV"] = "test"
    require "./spec/spec_helper"
  end
end

namespace :factory_girl do
  desc "Verify that all FactoryGirl factories are valid"
  task lint: "environment:test" do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint(traits: true)
    ensure
      DatabaseCleaner.clean
    end
  end
end

namespace :db do
  desc "Drop the database using RACK_ENV"
  task drop: :environment do
    Mongoid::Clients.default.database.drop
  end

  desc "Populate the database with sample data for the last year"
  task populate_for_last_year: :environment do
    Rake::Task["db:drop"].invoke

    create_events(Time.now.year, create_users)
  end

  desc "Populate the database with sample data for the last five years"
  task populate_for_last_five_years: :environment do
    Rake::Task["db:drop"].invoke

    require "active_support/testing/time_helpers"
    include ActiveSupport::Testing::TimeHelpers

    users = travel_to(4.years.ago) { create_users }

    (4.years.ago.year..0.years.ago.year).to_a.slice(0..-3).each do |year|
      create_events(year, users)
    end
  end

  def create_users
    team = Team.create!(tid: "T1", name: "Team 1")
    %w[john jack jane].map.with_index(1) do |nickname, i|
      User.create!(team: team, uid: "U#{i}", token: "fake", nickname: nickname)
    end
  end

  def create_events(year, users)
    rand(2..4).times do
      month = (year == Time.now.year) ? rand(1..Time.now.month) : rand(1..12)
      time = Time.new(year, month, Time.now.day, Time.now.hour)

      u1, u2 = users.sample(2)

      rand(0..4).times do
        User::CaptureEvent.call(u1, triggered_by: u2, triggered_at: time)
      end

      rand(0..2).times do
        User::CaptureEvent.call(u2, triggered_by: u1, triggered_at: time)
      end
    end
  end
end
