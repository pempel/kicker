require "request_helper"

describe "POST /slack/events" do
  context "when the event is url_verification" do
    before do
      post "/slack/events", {type: "url_verification", challenge: "challenge-1"}.to_json, {"CONTENT_TYPE" => "application/json"}
    end

    it "responds with the 200 status code" do
      expect(last_response.status).to eq(200)
    end

    it "responds with the challenge text" do
      expect(last_response.body).to eq("challenge-1")
    end
  end

  context "when the event is event_callback" do
    context "when the event type is team_domain_change" do
      let!(:team) do
        create(:team, tid: "T1", domain: "team-1")
      end

      let(:params) do
        build(:team_domain_change_event_hash, team_id: "T1", domain: "team-2")
      end

      before do
        post "/slack/events", params.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "sets the new domain of the team" do
        expect(team.reload.domain).to eq("team-2")
      end
    end

    context "when the event type is team_rename" do
      let!(:team) do
        create(:team, tid: "T1", name: "Team 1")
      end

      let(:params) do
        build(:team_rename_event_hash, team_id: "T1", name: "Team 2")
      end

      before do
        post "/slack/events", params.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "sets the new name of the team" do
        expect(team.reload.name).to eq("Team 2")
      end
    end

    context "when the event type is user_change" do
      let!(:user) do
        create(:user, uid: "U1", nickname: "jane", name: "Jane Doe")
      end

      let(:params) do
        build(:user_change_event_hash, uid: "U1", nickname: "judy", name: "Judy")
      end

      before do
        post "/slack/events", params.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "sets the new nickname of the user" do
        expect(user.reload.nickname).to eq("judy")
      end

      it "sets the new first name of the user" do
        expect(user.reload.first_name).to eq("Judy")
      end

      it "sets the new last name of the user" do
        expect(user.reload.last_name).to eq("")
      end
    end

    context "when the event type is something else" do
      before do
        post "/slack/events", {token: "token-1", challenge: "challenge-1"}.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end
    end
  end
end
