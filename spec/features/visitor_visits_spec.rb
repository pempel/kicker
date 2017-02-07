require "feature_helper"

feature "Visitor visits" do
  scenario "the welcome page" do
    visit "/"

    expect(page).to have_text("Welcome Page")
  end
end
