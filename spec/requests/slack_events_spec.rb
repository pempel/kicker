RSpec.describe "POST /slack/events" do
  let(:app) do
    Proudly.new
  end

  context "when the event is \"url_verification\"" do
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

  context "when the event is \"event_callback\"" do
    context "when the event type is \"user_change\"" do
      let!(:identity) do
        create(:identity,
          uid: "123",
          nickname: "nickname",
          first_name: "First Name",
          last_name: "Last Name"
        )
      end

      before do
        post "/slack/events", {type: "event_callback", event: {type: "user_change", user: {id: "123", name: "new-nickname", profile: {first_name: "New First Name", last_name: "New Last Name"}}}}.to_json, {"CONTENT_TYPE" => "application/json"}
      end

      it "responds with the 200 status code" do
        expect(last_response.status).to eq(200)
      end

      it "responds with the empty body" do
        expect(last_response.body).to eq("")
      end

      it "assigns the new nickname to the identity#nickname" do
        expect(identity.reload.nickname).to eq("new-nickname")
      end

      it "assigns the new first name to the identity#first_name" do
        expect(identity.reload.first_name).to eq("New First Name")
      end

      it "assigns the new last name to the identity#last_name" do
        expect(identity.reload.last_name).to eq("New Last Name")
      end
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
