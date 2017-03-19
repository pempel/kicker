class User::FindOrCreateByAuthHash < ApplicationService
  def initialize(hash = {})
    hash = hash.to_h.deep_symbolize_keys
    @info = hash.fetch(:info, {})
    @token = hash.fetch(:credentials, {}).fetch(:token, "")
  end

  def call
    user = User.where(uid: info[:user_id]).first
    if user.blank?
      user = User.new
      user.team = Team.where(tid: info[:team_id]).first
      user.team ||= Team.new(tid: info[:team_id], name: info[:team])
      user.identity = Identity.new
      user.uid = info[:user_id]
      user.token = token
      user.nickname = info[:nickname]
      user.first_name = info[:first_name]
      user.last_name = info[:last_name]
      user.save!
    end
    user
  end

  private

  attr_reader :info, :token
end
