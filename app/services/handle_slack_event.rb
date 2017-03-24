class HandleSlackEvent < ApplicationService
  def initialize(params)
    @params = params.to_h.deep_symbolize_keys
    @event_params = @params.fetch(:event, {})
  end

  def call
    type = event_params[:type]
    type.present? && respond_to?(type, true) ? send(type) : nil
  end

  private

  attr_reader :params, :event_params

  def team_domain_change
    domain = event_params[:domain]
    team = Team.where(tid: params[:team_id]).first
    if domain.present? && team.present?
      team.domain = domain
      team.save!
    end
  end

  def team_rename
    name = event_params[:name]
    team = Team.where(tid: params[:team_id]).first
    if name.present? && team.present?
      team.name = name
      team.save!
    end
  end

  def user_change
    user_params = event_params.fetch(:user, {})
    user_profile_params = user_params.fetch(:profile, {})

    uid = user_params[:id]
    nickname = user_params[:name]
    first_name = user_profile_params[:first_name]
    last_name = user_profile_params[:last_name]

    user = User.where(uid: uid).first
    if user.present?
      user.nickname = nickname
      user.first_name = first_name
      user.last_name = last_name
      user.save!
    end
  end
end
