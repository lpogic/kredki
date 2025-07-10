require_relative 'pad/service'
require_relative 'radiobox'

module Kredki
  module UI
    class RadioGroup < Service

      def radio! ...
        new(Radiobox, ...)
      end

      #internal api

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
        radios = self[Radiobox...].to_a
        radios[radios.index(radio) - 1]
      end

      def next_radio radio
        radios = self[Radiobox...].to_a
        radios[(radios.index(radio) + 1) % radios.size]
      end

      def set_checked radio, checked
        self[Radiobox...].select{ it.checked? }.each{ it.set_checked false } if checked
        radio.set_checked checked
      end
    end#RadioGroup
  end#UI
end