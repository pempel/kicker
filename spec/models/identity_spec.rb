describe Identity do
  it "cannot have different feeds associated with the same year" do
    identity = create(:identity)
    identity.feeds << build(:feed, year: 1999)
    identity.feeds << build(:feed, year: 1999)

    message = "is already taken"
    expect(identity.feeds.last.errors.messages[:year]).to include(message)
  end

  describe "#new" do
    it "builds the current feed associated with the current year" do
      travel_to(Time.parse("2018-02-23 10:15"))

      identity = Identity.new

      expect(identity.feed).to be_present
      expect(identity.feed.year).to eq(2018)
      expect(Feed.count).to eq(0)
    end
  end

  describe "#create" do
    it "creates the current feed associated with the current year" do
      travel_to(Time.parse("2018-02-23 10:15"))

      identity = create(:identity)

      identity.reload
      expect(identity.feed).to be_present
      expect(identity.feed.year).to eq(2018)
      expect(Feed.count).to eq(1)
      expect(Feed.first).to eq(identity.feed)
    end
  end

  describe "#destroy" do
    it "destroys all related feeds" do
      travel_to(Time.parse("2018-02-23 10:15"))
      identity = create(:identity)
      identity.feeds << build(:feed, year: 2019)
      identity.feeds << build(:feed, year: 2020)

      expect{identity.destroy}.to change(Feed, :count).from(3).to(0)
    end
  end
end
