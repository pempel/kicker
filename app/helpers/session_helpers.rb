module SessionHelpers
  def current_user
    @_current_user ||= User.where(id: session[:user_id]).first
  end

  def set_current_user(user)
    @_current_user = user
    session[:user_id] = user.try(:id).try(:to_s)
  end

  def previous_path
    session[:previous_path]
  end

  def set_previous_path(path)
    session[:previous_path] = path.to_s
  end
end
