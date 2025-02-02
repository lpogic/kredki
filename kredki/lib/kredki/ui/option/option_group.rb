module Kredki
  module UI
    class OptionGroup
      include Alterable

      class << self
        def [](prev_key = :up, next_key = :down)
          self.new.alter prev_key:, next_key:;
        end
      end

      model do
        @options = []
      end

      aliasing def prev_key! key
        @prev_key = key
      end, :prev_key=

      aliasing def next_key! key
        @next_key = key
      end, :next_key=


      #internal api

      def append pad
        @options << pad
      end

      def remove pad
        @options.delete pad
      end

      def key e
        case e.symbol
        when @prev_key
          option = update_select_option :previous
          option&.roi!
          e.resolve
        when @next_key
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