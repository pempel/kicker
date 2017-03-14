require "feature_helper"

feature "Team page" do
  let(:now) do
    Time.parse("2017-02-26 10:15")
  end

  before do
    travel_to(now)
  end

  let!(:team_1) do
    create(:team, tid: "T1")
  end

  let!(:team_2) do
    create(:team, tid: "T2")
  end

  let!(:jack) do
    create(:user, team: team_1, uid: "U1", nickname: "jack")
  end

  let!(:jane) do
    build(:user, team: team_1, uid: "U2", nickname: "jane") do |jane|
      jane.first_name = "Jane"
      jane.feed.events << create(:work_recognized, triggered_by: jack)
      jane.feed.events << create(:work_recognized, triggered_by: jack)
      jane.feed.events << begin
        create(:work_recognized, triggered_by: jack, created_at: now - 1.month)
      end
      jane.save!
    end
  end

  let!(:john) do
    build(:user, team: team_1, uid: "U3", nickname: "john") do |john|
      john.first_name = "John"
      john.last_name = "Doe"
      john.feed.events << create(:work_recognized, triggered_by: jane)
      john.feed.events << create(:work_recognized, triggered_by: jane)
      john.feed.events << create(:work_recognized, triggered_by: jane)
      john.save!
    end
  end

  let!(:june) do
    create(:user, team: team_2, uid: "U4", nickname: "june")
  end

  scenario "contains a table of team members with points" do
    as_slack_user("U1") { visit "/team?year=2017&month=2" }

    expect(page.all("table tbody td").map(&:text)).to eq([
      "3", "john", "John Doe",
      "2", "jane", "Jane",
      "0", "jack", "\u2014"
    ])
  end
end
