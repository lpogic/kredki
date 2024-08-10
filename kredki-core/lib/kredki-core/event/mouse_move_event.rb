require_relative 'event'

module Kredki
  class MouseMoveEvent < Event
    include EventWithWindowId

    model :mouse
  end
end