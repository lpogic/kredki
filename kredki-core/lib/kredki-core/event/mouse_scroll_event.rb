require_relative 'event'

module Kredki
  class MouseScrollEvent < AbiEvent

    model :mouse

    def alt?
      true
    end
  end
end