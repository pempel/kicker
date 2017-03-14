describe Identity do
  describe "#destroy" do
    it "destroys all related users" do
      identity = create(:identity)
      create_list(:user, 2, identity: identity)

      identity.destroy

      expect(User.count).to eq(0)
    end
  end
end
