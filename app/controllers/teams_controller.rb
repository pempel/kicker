class TeamsController < ApplicationController
  get "/team", auth: true do
    year, month = params["year"], params["month"]
    year, month, changed = ParseYearAndMonth.call(year, month)
    if changed
      redirect to(team_path(year: year, month: month))
    else
      @year = year
      @month = month
      @report = TeamReportPresenter.new(current_user.team)
      slim :team
    end
  end
end
