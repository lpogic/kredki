module Kredki
  module UI
    class RadioGroup
      include Alterable

      model do
        @radios = []
      end

      #internal api

      def append radio
        @radios << radio
      end

      def remove radio
        @radios.delete radio
      end

      def key event, radio
        case event.symbol
        when :up
          r = previous_radio radio
          r.focus!
          r.roi!
          event.resolve
        when :down
          r = next_radio radio
          r.focus!
          r.roi!
          event.resolve
        end
      end

      def previous_radio radio
        @radios[@radios.index(radio) - 1]
      end

      def next_radio radio
        @radios[(@radios.index(radio) + 1) % @radios.size]
      end

      def set_checked radio, checked
        @radios.select{ _1.checked? }.each{ _1.set_checked false } if checked
        radio.set_checked checked
      end
    end#RadioGroup
  end#UI
end