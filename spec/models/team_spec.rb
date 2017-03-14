describe Team do
  describe "#new" do
    it "builds the new team with the default settings" do
      team = Team.new

      expect(team.settings).to be_present
      expect(team.settings.github_integration_enabled).to eq(false)
      expect(team.settings.github_repositories).to eq([])
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
