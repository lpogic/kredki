module Kredki
  class MouseButtonEvent < AbiEvent
    
    model :mouse, :abi!, :target!

    def button
      @mouse.button(@abi.button).to_sym
    end

    def symbol
      button
    end

    def button_number
      @abi.button
    end

    def repeat?
      @abi.clicks > 0
    end

    def clicks
      @abi.clicks
    end

    def x
      @abi.x
    end

    def y
      @abi.y
    end

    def [](key = :button)
      send key
    end
  end

  class MouseButtonDownEvent < MouseButtonEvent
  end

  class MouseButtonUpEvent < MouseButtonEvent
  end
end