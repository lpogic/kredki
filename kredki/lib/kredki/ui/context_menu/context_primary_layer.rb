require_relative 'context_layer'

module Kredki
  module UI
    class ContextPrimaryLayer < ContextLayer

      def load! x, y
        arrange
        action = parent.action
        x_max = action.w - @items.sw 
        x = [x_max, 0].max if x > x_max
        sh = @items.sh
        y = [y - sh, 0].max if y + sh > action.h
        load_common x, y
      end

      #internal api

      def sketch p0
        super

        on! Item::PickEvent, aim: true do |e|
          if e.target.has_subitem?
            e.resolve
          else
            pad_detach
          end
        end

        on_key! :escape do |e|
          pad_detach
          e.resolve
        end

        on_mouse_down! do |e|
          pad_detach
        end
      end

      def mouse_enter e
        super
        e.resolve
      end

      def mouse_leave e
        super
        e.resolve
      end

      def mouse_move e
        super
        e.resolve
      end
    end
  end
end