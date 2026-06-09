module Kredki
  class Preset
    def initialize *arguments, **keyword_arguments, &block
      @arguments = arguments
      @keyword_arguments = keyword_arguments
      @block = block
    end

    attr :arguments
    attr :keyword_arguments
    attr :block
  end
end