require "feature_helper"

feature "Team page" do
  let(:now) do
    Time.parse("2017-02-26 10:15")
  end

  before do
    travel_to(now)
  end

  let!(:jane) do
    build(:identity, tid: "T1", uid: "U1", nickname: "jane") do |jane|
      jane.first_name = "Jane"
      jane.feed.events << create(:work_recognized, created_at: now - 1.month)
      jane.feed.events << create(:work_recognized)
      jane.feed.events << create(:work_recognized)
      jane.save!
    end
  end

  let!(:john) do
    build(:identity, tid: "T1", uid: "U2", nickname: "john").tap do |john|
      john.first_name = "John"
      john.last_name = "Doe"
      john.feed.events << create(:work_recognized)
      john.feed.events << create(:work_recognized)
      john.feed.events << create(:work_recognized)
      john.save!
    end
  end

  let!(:jack) do
    create(:identity, tid: "T1", uid: "U3", nickname: "jack")
  end

  let!(:june) do
    create(:identity, tid: "T2", uid: "U4", nickname: "june")
  end

  scenario "contains a table of team members with points" do
    mock_slack_auth_hash(uid: "U1") do
      visit "/team"
    end

    expect(page.all("table tbody td").map(&:text)).to eq([
      "3", "john", "John Doe",
      "2", "jane", "Jane",
      "0", "jack", ""
    ])
  end
end
