class TeamSettings
  include Mongoid::Document

  embedded_in :team

  field :github_integration_enabled, type: Boolean, default: false
  field :github_repositories, type: Array, default: []
end
