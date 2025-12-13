module Kredki
  # Event reported on text entered.
  class TextEvent < PasteleEvent
    
    # Entered content.
    def text
      @text
    end

    # :section: LEVEL 2

    def initialize ptr, abi
      super abi

      @text = @abi.text.to_s.force_encoding("utf-8")
    end

    def param
      text
    end
  end
end