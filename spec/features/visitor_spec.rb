require "feature_helper"

feature "Visitor" do
  scenario "visits the welcome page" do
    visit "/"

    expect(page).to have_current_path("/")
    expect(page).to have_text("Welcome Page")
    expect(page).to have_link("", href: "/team")
  end

  scenario "visits the team page after she has signed in successfully" do
    identity = create(:identity, nickname: "jane-doe")

    mock_slack_auth_hash(uid: identity.uid) do
      visit "/team"
    end
    visit "/team"

    expect(page).to have_current_path("/team")
    expect(page).to have_text("Team Page")
    expect(page).to have_text("jane-doe")
  end
end
