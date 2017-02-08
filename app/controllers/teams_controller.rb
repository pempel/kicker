class TeamsController < ApplicationController
  get "/team", auth: true do
    slim :team
  end
end
