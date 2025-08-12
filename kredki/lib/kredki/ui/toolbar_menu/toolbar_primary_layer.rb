module Kredki
  module UI
    class ToolbarPrimaryLayer < ToolbarLayer

      def load! item
        # arrange
        # action = parent.action
        # x, y = *item.translate(-item.area.xs, -item.area.ys)
        # w = action.w * 0.5
        # x_max = w - @items.sw
        # x = [x_max, -w].max if x > x_max
        # h = action.h * 0.5
        # y_min = @items.sh - h
        # if y < y_min
        #   y_max = y + item.sh + @items.sh
        #   if y_max < h
        #     y = y_max
        #   else
        #     y = h
        #   end
        # end
        # load_common x + @items.area.xs, y - @items.area.ys

        arrange
        action = parent.action
        x, y = *item.translate(0, item.sh)
        if x + @items.sw > action.sw
          x = [x - item.sw - @items.sw, 0].max
        end
        if y + @items.sh > action.sh
          y = [action.sh - @items.sh, 0].max
        end
        load_common x, y
      end

      #internal api

      def sketch p0
        super

        on! Item::PickEvent do |e|
          if e.target.has_subitem?
            e.resolve
          else
            parent.report e
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

      def set_parent parent, at = nil
        super and (
          @parent_events&.each{ _1.detach! }
          @parent_events = []


          @parent_events[] = parent.on_focus_enter! do |e|
            load! parent
          end

          @parent_events[] = parent.on_focus_leave! do |e|
            unload! if loaded?
          end
        )
      end

      # def mouse_enter e
      #   super
      #   e.resolve
      # end

      # def mouse_leave e
      #   super
      #   e.resolve
      # end

      # def mouse_move e
      #   super
      #   e.resolve
      # end
    end
  end
end