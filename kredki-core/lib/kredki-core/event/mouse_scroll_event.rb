require_relative 'event'

module Kredki
  class MouseScrollEvent < Event
    include EventWithWindowId

    model :mouse
  end
end