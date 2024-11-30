require_relative '../grid/grid_pad'

module Kredki
  module UI
    class Options < GridPad

      #internal api

      def sketch p0
        super

        direction! :row
        autosized! true
        keyboardy! true

        on_key! do |e|
          case e.symbol
          when :up
            option = update_select_option :previous
            option&.report ROIEvent.new *option.wh, *option.translate(*option.xy)
            e.resolve
          when :down
            option = update_select_option :next
            option&.report ROIEvent.new *option.wh, *option.translate(*option.xy)
            e.resolve
          end
        end
      end

      def update_select_option option
        case option
        when :previous
          if option = self[Option..].lazy.each_cons(2).find{ _1[1].keyboard_in? }&.slice(0)
            update_select_option option
          else
            update_select_option self[Option]
          end
        when :next
          if option = self[Option..].lazy.each_cons(2).find{ _1[0].keyboard_in? }&.slice(1)
            update_select_option option
          else
            update_select_option self[Option] unless self[Option, reverse: true].keyboard_in?
          end
        else
          option&.gain_keyboard
          option
        end
      end
    end
  end
end