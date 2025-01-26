module Kredki
  module UI
    class Options
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

      def update_select_option option
        case option
        when :previous
          if option = @options.lazy.each_cons(2).find{ _1[1].keyboard_in? }&.slice(0)
            update_select_option option
          else
            update_select_option @options.first
          end
        when :next
          if option = @options.lazy.each_cons(2).find{ _1[0].keyboard_in? }&.slice(1)
            update_select_option option
          else
            update_select_option @options.first unless @options.last.keyboard_in?
          end
        else
          option&.gain_keyboard
          option
        end
      end

    end#Options
  end#UI
end