module ApplicationConditions
  def auth(required)
    condition do
      if required && current_user.blank?
        set_previous_path(request.fullpath)
        redirect "/signin"
      end
    end
  end
end
