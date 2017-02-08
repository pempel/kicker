module ApplicationHelpers
  def current_identity
    @current_identity ||= Identity.where(id: session[:identity_id]).first
  end

  def set_current_identity(identity)
    @current_identity = identity
    session[:identity_id] = identity.try(:id).try(:to_s)
  end
end
