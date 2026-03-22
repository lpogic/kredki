module Kredki
  module Pads
    module DisabledFeature
      # Set whether is disabled.
      def set_disabled value = true
        return if (c = disabled) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @disabled = value
        repaint
        true
      end

      # See #set_disabled.
      def disabled= value
        set_disabled value
      end
      
      # Get whether is disabled.
      def disabled flat = false
        @disabled || (!flat && find_lower(Pad){|it| it.disabled })
      end
    end
  end
end