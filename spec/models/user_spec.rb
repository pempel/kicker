describe User do
  it "cannot have different feeds associated with the same year" do
    user = create(:user)
    user.feeds << build(:feed, year: 1999)
    user.feeds << build(:feed, year: 1999)

    message = "is already taken"
    expect(user.feeds.last.errors.messages[:year]).to include(message)
  end

  describe "#new" do
    it "builds the current feed associated with the current year" do
      travel_to(Time.parse("2018-02-23 10:15"))

      user = User.new

      expect(user.feed).to be_present
      expect(user.feed.year).to eq(2018)
      expect(Feed.count).to eq(0)
    end
  end

  describe "#create" do
    it "creates the current feed associated with the current year" do
      travel_to(Time.parse("2018-02-23 10:15"))

      user = create(:user)

      user.reload
      expect(user.feed).to be_present
      expect(user.feed.year).to eq(2018)
      expect(Feed.count).to eq(1)
      expect(Feed.first).to eq(user.feed)
    end
  end

  describe "#destroy" do
    it "destroys all related feeds" do
      travel_to(Time.parse("2018-02-23 10:15"))
      user = create(:user)
      user.feeds << build(:feed, year: 2019)
      user.feeds << build(:feed, year: 2020)

      expect{user.destroy}.to change(Feed, :count).from(3).to(0)
    end
  end

  describe "#name" do
    context "when the first name and the last name are present" do
      it "returns the correct name" do
        user = build(:user, first_name: "First", last_name: "Last")

        expect(user.name).to eq("First Last")
      end
    end

    context "when the first name and the last name are blank" do
      it "returns the correct name" do
        user = build(:user, first_name: nil, last_name: nil)

        expect(user.name).to eq("")
      end
    end

    context "when the first name is blank" do
      it "returns the correct name" do
        user = build(:user, first_name: nil, last_name: "Last")

        expect(user.name).to eq("Last")
      end
    end

    context "when the last name is blank" do
      it "returns the correct name" do
        user = build(:user, first_name: "First", last_name: nil)

        expect(user.name).to eq("First")
      end
    end
  end
end
