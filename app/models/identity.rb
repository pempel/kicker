class Identity
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :users, dependent: :destroy
end
