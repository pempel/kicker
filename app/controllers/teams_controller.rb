class TeamsController < ApplicationController
  get "/team", auth: true do
    @members = TeamMembersPresenter.new(tid: current_identity.tid).members
    slim :team
  end
end
