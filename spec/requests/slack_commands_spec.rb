require "request_helper"

describe "POST /slack/commands/proud_of" do
  context "when the request is the verification of the SSL certificate" do
    before do
      post "/slack/commands/proud_of", {ssl_check: 1}
    end

    it "responds with the 200 status code" do
      expect(last_response.status).to eq(200)
    end

    it "responds with the empty body" do
      expect(last_response.body).to eq("")
    end
  end

  context "when the request is the proud_of slack command" do
    let(:now) do
      Time.parse("2017-02-24 09:15")
    end

    before do
      travel_to(now)
    end

    context "when the existing user is proud of another existing user" do
      let!(:john) do
        create(:user, uid: "U1", nickname: "john")
      end

      let!(:jane) do
        build(:user, uid: "U2", nickname: "jane") do |jane|
          jane.feed.events << build(:work_recognized, triggered_by: john)
          jane.feed.events << build(:work_recognized, triggered_by: john)
          jane.save!
        end
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the correct text" do
        expect(last_response.body).to eq("You are proud of jane.")
      end

      it "creates the correct event for the another user" do
        user = User.where(uid: "U2").first
        events = user.feed.events
        expect(events.size).to eq(3)
        expect(events.last).to be_an_instance_of(Event::WorkRecognized)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end

    context "when the existing user is proud of another non-existing user" do
      let!(:john) do
        team = build(:team, tid: "T1")
        create(:user, team: team, uid: "U1", nickname: "john")
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the correct text" do
        expect(last_response.body).to eq("You are proud of jane.")
      end

      it "creates the another user" do
        user = User.where(uid: "U2").first
        expect(user).to be_present
        expect(user.team.tid).to eq("T1")
        expect(user.uid).to eq("U2")
        expect(user.nickname).to eq("jane")
      end

      it "creates the correct event for the another user" do
        user = User.where(uid: "U2").first
        events = user.feed.events
        expect(events.size).to eq(1)
        expect(events.last).to be_an_instance_of(Event::WorkRecognized)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end

    context "when the non-existing user is proud of another existing user" do
      let!(:jane) do
        team = build(:team, tid: "T1")
        build(:user, team: team, uid: "U2", nickname: "jane") do |jane|
          jane.feed.events << build(:work_recognized)
          jane.save!
        end
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the correct text" do
        expect(last_response.body).to eq("You are proud of jane.")
      end

      it "creates the user" do
        user = User.where(uid: "U1").first
        expect(user).to be_present
        expect(user.team.tid).to eq("T1")
        expect(user.uid).to eq("U1")
        expect(user.nickname).to eq("john")
      end

      it "creates the correct event for the another user" do
        user = User.where(uid: "U2").first
        events = user.feed.events
        expect(events.size).to eq(2)
        expect(events.last).to be_an_instance_of(Event::WorkRecognized)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end
  end
end
