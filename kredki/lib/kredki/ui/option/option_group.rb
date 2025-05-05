module Kredki
  module UI
    class OptionGroup
      include Alterable

      model do
        @options = []
      end

      #internal api

      def append pad
        @options << pad
      end

      def remove pad
        @options.delete pad
      end

      def key e
        case e.symbol
        when :up
          option = update_select_option :previous
          option&.roi!
          e.resolve
        when :down
          option = update_select_option :next
          option&.roi!
          e.resolve
        end
      end

      def mouse_enter pad
        current_open = @options.find{ it.keyboard_in? }
        if current_open && current_open != pad
          current_open.focus! false
          pad.focus!
        end
      end

      def update_select_option option
        case option
        when :previous
          index = (@options.index{ it.keyboard_in? } || 1) - 1
          update_select_option @options[index]
        when :next
          index = (@options.index{ it.keyboard_in? } || -1) + 1
          update_select_option @options[index < @options.length ? index : 0]
        else
          option&.gain_keyboard
          option
        end
      end

    end#OptionGroup
  end#UI
end