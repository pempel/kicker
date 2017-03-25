require "feature_helper"

feature "Users sign up" do
  scenario "with the same team" do
    as_slack_user(uid: "U1", tid: "T1") do
      visit "/dashboard"
      visit "/signout"
    end
    as_slack_user(uid: "U2", tid: "T1") do
      visit "/dashboard"
    end

    expect(User.where(uid: "U1").first.try(:team).try(:tid)).to eq("T1")
    expect(User.where(uid: "U2").first.try(:team).try(:tid)).to eq("T1")
  end

  scenario "with different teams" do
    as_slack_user(uid: "U1", tid: "T1") do
      visit "/dashboard"
      visit "/signout"
    end
    as_slack_user(uid: "U2", tid: "T2") do
      visit "/dashboard"
    end

    expect(User.where(uid: "U1").first.try(:team).try(:tid)).to eq("T1")
    expect(User.where(uid: "U2").first.try(:team).try(:tid)).to eq("T2")
  end
end
