class WelcomeController < ApplicationController
  get "/" do
    slim :welcome
  end
end
