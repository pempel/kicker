require "feature_helper"

feature "User" do
  scenario "visits the welcome page" do
    visit "/"

    expect(page).to have_current_path("/")
    expect(page).to have_text("I am so proud_of you")
    expect(page).to have_link("Sign in", href: "/signin")
  end

  scenario "visits the team page after she has signed in successfully" do
    create(:identity, uid: "U1", nickname: "jane")

    mock_slack_auth_hash(uid: "U1") do
      visit "/team"
    end
    visit "/team"

    expect(page).to have_current_path("/team")
    expect(page).to have_text("I am so proud_of you, jane")
  end

  scenario "signs in with different accounts" do
    user = create(:user)
    user.identities << create(:identity, uid: "U1", nickname: "jane")
    user.identities << create(:identity, uid: "U2", nickname: "june")

    mock_slack_auth_hash(uid: "U1") do
      visit "/team"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("I am so proud_of you, jane")

    visit "/signout"

    expect(page).to have_current_path("/")
    expect(page).to have_text("I am so proud_of you")

    mock_slack_auth_hash(uid: "U2") do
      visit "/team"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("I am so proud_of you, june")
  end

  scenario "merges one account with another" do
    jane = create(:identity, uid: "U1", nickname: "jane")
    jane_user_id = jane.user.id.to_s

    mock_slack_auth_hash(uid: "U1") do
      visit "/team"
    end
    mock_slack_auth_hash(uid: "U2", nickname: "june") do
      visit "/signin"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("I am so proud_of you, june")
    expect(User.count).to eq(1)
    expect(User.first.id.to_s).to eq(jane_user_id.to_s)
    expect(User.first.identities.map(&:uid)).to contain_exactly("U1", "U2")
  end
end
