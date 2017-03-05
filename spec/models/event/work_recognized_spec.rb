describe Event::WorkRecognized do
  describe "#new" do
    it "builds the new event with 1 point by default" do
      event = described_class.new

      expect(event.points).to eq(1)
    end
  end
end
