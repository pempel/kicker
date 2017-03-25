module UrlHelpers
  def current_path
    request.fullpath
  end

  def current_params
    request.params.deep_symbolize_keys
  end

  def dashboard_path(type: nil, tid: nil, uid: nil, year: nil, month: nil)
    type = "overview" if type.blank?
    params = {type: type, tid: tid, uid: uid, year: year, month: month}
    path = URI("/dashboard")
    path.query = URI.encode_www_form(params.compact)
    path.to_s
  end

  def main_dashboard_path
    now = Time.now
    dashboard_path(tid: current_user.team.tid, year: now.year, month: now.month)
  end
end
