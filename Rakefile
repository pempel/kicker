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

    identities = %w[john jack jane].map.with_index(1) do |nickname, i|
      Identity.create!(tid: "T1", uid: "U#{i}", nickname: nickname)
    end

    populate(Time.now.year, identities)
  end

  desc "Populate the database with sample data for the last three years"
  task populate_for_last_three_years: :environment do
    Rake::Task["db:drop"].invoke

    require "active_support/testing/time_helpers"
    include ActiveSupport::Testing::TimeHelpers

    years = (2.years.ago.year..0.years.ago.year).to_a

    identities = travel_to(Time.new(years.first)) do
      %w[john jack jane].map.with_index(1) do |nickname, i|
        Identity.create!(tid: "T1", uid: "U#{i}", nickname: nickname)
      end
    end

    years.select.with_index { |_, i| i.even? }.each do |year|
      populate(year, identities)
    end
  end

  def populate(year, identities)
    rand(2..4).times do
      i1, i2 = identities.sample(2)
      time = Time.new(year, rand(1..12), Time.now.day, Time.now.hour)

      rand(0..4).times do
        Identity::CaptureEvent.call(i1, triggered_by: i2, triggered_at: time)
      end

      rand(0..2).times do
        Identity::CaptureEvent.call(i2, triggered_by: i1, triggered_at: time)
      end
    end
  end
end
