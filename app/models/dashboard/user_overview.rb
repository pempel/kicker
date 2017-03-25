class Dashboard::UserOverview < Dashboard
  def info
    "User: #{user.try(:nickname)}"
  end
end
