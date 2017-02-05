class User
  include Mongoid::Document

  has_many :identities, dependent: :destroy
end
