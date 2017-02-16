describe Identity do
  describe "#new" do
    it "builds the current feed associated with the current year" do
      travel_to Time.new(2018, 2, 23, 10, 15)

      identity = build(:identity)

      expect(identity.feed).to be_present
      expect(identity.feed.year).to eq(2018)
      expect(Feed.count).to eq(0)
    end
  end

  describe "#create" do
    it "creates the current feed associated with the current year" do
      travel_to Time.new(2018, 2, 23, 10, 15)

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
      identity = create(:identity)

      identity.destroy

      expect(Feed.count).to eq(0)
    end
  end
end
