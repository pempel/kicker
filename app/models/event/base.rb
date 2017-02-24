class Event::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :eventable, polymorphic: true
end
