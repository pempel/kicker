namespace :factory_girl do
  desc "Verify that all FactoryGirl factories are valid"
  task :lint do
    require "./spec/spec_helper"
    begin
      DatabaseCleaner.start
      FactoryGirl.lint(traits: true)
    ensure
      DatabaseCleaner.clean
    end
  end
end
