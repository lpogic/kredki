module Kredki
  class MouseButtonEvent < Event
    
    model :mouse

    def symbol
      @mouse.button(@abi.button).to_sym
    end

    def button
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

    def [](key = :symbol)
      send key
    end
  end

  class MouseButtonDownEvent < MouseButtonEvent
  end

  class MouseButtonUpEvent < MouseButtonEvent
  end
end