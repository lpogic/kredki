require_relative 'event'

module Kredki
  class TextEvent < AbiEvent
    
    def initialize ptr, abi
      super abi

      @text = (ptr + 12).to_s.force_encoding("utf-8")
    end

    attr :text

    def [](key = :text)
      send key
    end
  end
end