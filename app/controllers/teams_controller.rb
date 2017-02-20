class TeamsController < ApplicationController
  get "/team", auth: true do
    @report = TeamReportPresenter.new(tid: current_identity.tid)
    slim :team
  end
end
