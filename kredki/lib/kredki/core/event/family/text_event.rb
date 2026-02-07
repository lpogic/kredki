module Kredki
  # Event reported on text entered.
  class TextInputEvent < PasteleEvent
    
    # Entered content.
    def text
      @text
    end

    # Get main parameter
    def param
      text
    end

    # :section: LEVEL 2

    def initialize ptr, abi
      super abi

      @text = @source.text.to_s.force_encoding("utf-8")
    end
  end
end