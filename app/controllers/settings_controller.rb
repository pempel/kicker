class SettingsController < ApplicationController
  get "/settings/:id" do
    slim :settings
  end
end
