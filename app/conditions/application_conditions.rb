module ApplicationConditions
  def auth(required)
    condition do
      if required && current_identity.blank?
        redirect "/signin"
      end
    end
  end
end
