describe Team do
  describe "#destroy" do
    it "destroys all related identities" do
      team = create(:team)
      create_list(:identity, 2, team: team)

      team.destroy

      expect(Identity.count).to eq(0)
    end
  end
end
