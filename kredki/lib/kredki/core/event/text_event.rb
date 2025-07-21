require_relative 'event'

module Kredki
  class TextEvent < AbiEvent
    
    def initialize ptr, abi
      super abi

      @text = @abi.text.to_s.force_encoding("utf-8")
    end

    attr :text

    def ~()
      text
    end
  end
end