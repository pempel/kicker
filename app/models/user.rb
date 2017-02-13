class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :identities, dependent: :destroy
end
