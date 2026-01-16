module Kredki
  # Event reported on drop.
  class DropEvent < PasteleEvent
    
    # Get data.
    def data
      @data
    end

    # Get whether it is multi drop event.
    def multi?
      @data.size > 1
    end

    # Get first dropped object text.
    def text
      @data.first.text
    end

    # Get main parameter
    def param
      text
    end

    # :section: LEVEL 2

    def initialize data, ...
      super(...)
      @data = data
    end
  end
  
  # Event reported on drop action begin.
  class DropBeginEvent < PasteleEvent
  end

  # Event reported on drop action cancel.
  class DropCancelEvent < DropEvent
  end
end