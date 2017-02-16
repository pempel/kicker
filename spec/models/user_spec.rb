describe User do
  describe "#destroy" do
    it "destroys all related identities" do
      user = create(:user)
      create_list(:identity, 2, user: user)

      user.destroy

      expect(Identity.count).to eq(0)
    end
  end
end
