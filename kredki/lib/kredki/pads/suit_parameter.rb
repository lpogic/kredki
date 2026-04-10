module Kredki
  module Pads
    # Common suit parameter model.
    module SuitParameter

      # Set suit.
      def set_suit *suit
        return send_bundle :set_suit, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      # See #set_suit.
      def suit= param
        send_bundle :set_suit, param
      end

      # Get suit.
      def suit
        @suit
      end

    end
  end
end