module ApplicationHelpers
  def current_identity
    @current_identity ||= Identity.where(id: session[:identity_id]).first
  end

  def set_current_identity(identity)
    @current_identity = identity
    session[:identity_id] = identity.try(:id).try(:to_s)
  end

  def previous_path
    session[:previous_path]
  end

  def set_previous_path(path)
    session[:previous_path] = path.to_s
  end

  def current_path
    request.fullpath
  end

  def team_path(year: nil, month: nil)
    if year.blank? && month.blank?
      now = Time.now
      year, month = now.year, now.month
    else
      year, month = ParseYearAndMonth.call(year, month)
    end
    path = URI("/team")
    path.query = URI.encode_www_form({year: year, month: month}.compact)
    path.to_s
  end
end
