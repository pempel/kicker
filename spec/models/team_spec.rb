describe Team do
  describe "#new" do
    it "builds the new team with the correct default values" do
      team = Team.new

      expect(team.tid).to eq(nil)
      expect(team.name).to eq(nil)
      expect(team.github_integration_enabled).to eq(false)
      expect(team.github_repositories).to eq([])
    end
  end

  describe "#destroy" do
    it "destroys all related users" do
      team = create(:team)
      create_list(:user, 2, team: team)

      team.destroy

      expect(User.count).to eq(0)
    end
  end
end
