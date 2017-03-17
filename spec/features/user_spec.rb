require "feature_helper"

feature "User" do
  scenario "visits the welcome page" do
    visit "/"

    expect(page).to have_current_path("/")
    expect(page).to have_text("Keep calm and carry on")
    expect(page).to have_link("Sign in", href: "/signin")
  end

  scenario "visits the team page after she has signed in successfully" do
    create(:user, uid: "U1", nickname: "jane")

    as_slack_user(uid: "U1") { visit "/team" }
    visit "/team"

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("Keep calm and carry on, jane")
  end

  scenario "signs in with different accounts" do
    identity = create(:identity)
    identity.users << create(:user, uid: "U1", nickname: "jane")
    identity.users << create(:user, uid: "U2", nickname: "june")

    as_slack_user(uid: "U1") { visit "/team" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("Keep calm and carry on, jane")

    visit "/signout"

    expect(page).to have_current_path("/")
    expect(page).to have_text("Keep calm and carry on")

    as_slack_user(uid: "U2") { visit "/team" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("Keep calm and carry on, june")
  end

  scenario "gets a token after sign up" do
    as_slack_user(token: "token-1-2-3") { visit "/team" }

    expect(User.first.token).to eq("token-1-2-3")
  end

  scenario "merges one account with another" do
    jane = create(:user, uid: "U1", nickname: "jane")
    jane_identity_id = jane.identity.id

    as_slack_user(uid: "U1") { visit "/team" }
    as_slack_user(uid: "U2", nickname: "june") { visit "/signin" }

    expect(page).to have_current_path("/team?year=#{Time.now.year}")
    expect(page).to have_text("Keep calm and carry on, june")
    expect(Identity.count).to eq(1)
    expect(Identity.first.id.to_s).to eq(jane_identity_id.to_s)
    expect(Identity.first.users.map(&:uid)).to contain_exactly("U1", "U2")
  end
end
