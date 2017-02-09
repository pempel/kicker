require "feature_helper"

feature "User" do
  scenario "visits the welcome page" do
    visit "/"

    expect(page).to have_current_path("/")
    expect(page).to have_text("Welcome Page")
    expect(page).to have_link("", href: "/team")
  end

  scenario "visits the team page after she has signed in successfully" do
    identity = create(:identity, uid: "i1", nickname: "jane-doe")

    mock_slack_auth_hash(uid: "i1") do
      visit "/team"
    end
    visit "/team"

    expect(page).to have_current_path("/team")
    expect(page).to have_text("Team Page")
    expect(page).to have_text("jane-doe")
  end

  scenario "signs in with different accounts" do
    user = create(:user)
    create(:identity, user: user, uid: "i1", nickname: "jane-doe-1")
    create(:identity, user: user, uid: "i2", nickname: "jane-doe-2")

    mock_slack_auth_hash(uid: "i1") do
      visit "/team"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("jane-doe-1")

    visit "/signout"

    expect(page).to have_current_path("/")
    expect(page).to have_text("Welcome Page")

    mock_slack_auth_hash(uid: "i2") do
      visit "/team"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("jane-doe-2")
  end

  scenario "merges one account with another" do
    identity = create(:identity, uid: "i1", nickname: "jane-doe-1")
    identity_user_id = identity.user.id

    mock_slack_auth_hash(uid: "i1") do
      visit "/team"
    end
    mock_slack_auth_hash(uid: "i2", nickname: "jane-doe-2") do
      visit "/signin"
    end

    expect(page).to have_current_path("/team")
    expect(page).to have_text("jane-doe-2")
    expect(User.count).to eq(1)
    expect(User.first.id.to_s).to eq(identity_user_id.to_s)
    expect(User.first.identities.map(&:uid)).to contain_exactly("i1", "i2")
  end
end
