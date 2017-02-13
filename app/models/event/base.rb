module Event
  class Base
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :eventable, polymorphic: true
  end
end
