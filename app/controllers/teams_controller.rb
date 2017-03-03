class TeamsController < ApplicationController
  get "/team", auth: true do
    year, month, changed = ParseYearAndMonth.call(params[:year], params[:month])
    if changed
      redirect team_path(year: year, month: month)
    else
      @year = year
      @month = month
      @report = TeamReportPresenter.new(current_identity.tid)
      slim :team
    end
  end
end
