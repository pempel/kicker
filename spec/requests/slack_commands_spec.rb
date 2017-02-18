require "request_helper"

describe "POST /slack/commands/proud_of" do
  context "when the request is the verification of the SSL certificate" do
    before do
      post "/slack/commands/proud_of", {ssl_check: 1}.to_json, {"CONTENT_TYPE" => "application/json"}
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
        create(:identity, tid: "T1", uid: "U1", nickname: "john")
      end

      let!(:jane) do
        jane = create(:identity, tid: "T1", uid: "U2", nickname: "jane")
        jane.feed.events << build(:points_earned, points: 2)
        jane.feed.events << build(:points_earned, points: 2)
        jane
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "creates the correct event for the another user" do
        identity = Identity.where(tid: "T1", uid: "U2").first
        events = identity.feed.events
        expect(events.size).to eq(3)
        expect(events.last).to be_an_instance_of(Event::PointsEarned)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end

    context "when the existing user is proud of another non-existing user" do
      let!(:john) do
        create(:identity, tid: "T1", uid: "U1", nickname: "john")
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "creates the another user" do
        identity = Identity.where(tid: "T1", uid: "U2").first
        expect(identity).to be_present
        expect(identity.tid).to eq("T1")
        expect(identity.uid).to eq("U2")
        expect(identity.nickname).to eq("jane")
      end

      it "creates the correct event for the another user" do
        identity = Identity.where(tid: "T1", uid: "U2").first
        events = identity.feed.events
        expect(events.size).to eq(1)
        expect(events.last).to be_an_instance_of(Event::PointsEarned)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end

    context "when the non-existing user is proud of another existing user" do
      let!(:jane) do
        jane = create(:identity, tid: "T1", uid: "U2", nickname: "jane")
        jane.feed.events << build(:points_earned, points: 2)
        jane
      end

      before do
        post "/slack/commands/proud_of", {team_id: "T1", user_id: "U1", user_name: "john", command: "/proud_of", text: "some unnecessary text <@U2|jane> and maybe more text"}.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "creates the user" do
        identity = Identity.where(tid: "T1", uid: "U1").first
        expect(identity).to be_present
        expect(identity.tid).to eq("T1")
        expect(identity.uid).to eq("U1")
        expect(identity.nickname).to eq("john")
      end

      it "creates the correct event for the another user" do
        identity = Identity.where(tid: "T1", uid: "U2").first
        events = identity.feed.events
        expect(events.size).to eq(2)
        expect(events.last).to be_an_instance_of(Event::PointsEarned)
        expect(events.last.points).to eq(1)
        expect(events.last.created_at).to eq(now)
      end
    end
  end
end
