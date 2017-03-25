class DashboardController < ApplicationController
  get "/dashboard", auth: true do
    @dashboard = Dashboard.build(current_user, params)
    if @dashboard.blank?
      slim :"dashboard/unknown"
    elsif @dashboard.invalid?
      slim :"dashboard/invalid"
    else
      slim :"dashboard/#{@dashboard.name}"
    end
  end
end
