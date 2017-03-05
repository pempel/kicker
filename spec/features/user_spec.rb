require "feature_helper"

feature "User" do
  scenario "visits the welcome page" do
    visit "/"

    expect(page).to have_current_path("/")
    expect(page).to have_text("I am proud_of you")
    expect(page).to have_link("Sign in", href: "/signin")
  end

  scenario "visits the team page after she has signed in successfully" do
    create(:identity, slack_id: "U1", nickname: "jane")

    as_slack_user("U1") { visit "/team" }
    visit "/team"

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("I am proud_of you, jane")
  end

  scenario "signs in with different accounts" do
    user = create(:user)
    user.identities << create(:identity, slack_id: "U1", nickname: "jane")
    user.identities << create(:identity, slack_id: "U2", nickname: "june")

    as_slack_user("U1") { visit "/team" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("I am proud_of you, jane")

    visit "/signout"

    expect(page).to have_current_path("/")
    expect(page).to have_text("I am proud_of you")

    as_slack_user("U2") { visit "/team" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("I am proud_of you, june")
  end

  scenario "merges one account with another" do
    jane = create(:identity, slack_id: "U1", nickname: "jane")
    jane_user_id = jane.user.id.to_s

    as_slack_user("U1") { visit "/team" }
    as_slack_user("U2", nickname: "june") { visit "/signin" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("I am proud_of you, june")
    expect(User.count).to eq(1)
    expect(User.first.id.to_s).to eq(jane_user_id.to_s)
    expect(User.first.identities.map(&:slack_id)).to contain_exactly("U1", "U2")
  end
end
