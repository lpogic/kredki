module Kredki
  class Event
    def default_closer
      caller
    end
  end
end