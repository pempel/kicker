class SettingsController < ApplicationController
  get "/settings/user", auth: true do
    @teams = current_user.identity.users.map(&:team)
    slim :"settings/user"
  end

  get "/settings/teams/:domain", auth: true do
    @teams = current_user.identity.users.map(&:team)
    @team = @teams.find { |t| t.domain == params["domain"] }
    slim :"settings/team"
  end

  patch "/settings/teams/:domain", auth: true do
    domain = params["domain"]
    team = Team.where(domain: domain).first
    if team.present?
      settings = params["settings"].to_h
      team.update!(settings.slice("reaction_points"))
    end
    redirect to("/settings/teams/#{domain}")
  end
end
