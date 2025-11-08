module Kredki
  module UI
    class ToolbarPrimaryLayer < ToolbarLayer

      def load! item
        arrange
        action = parent.action
        x, y = *item.translate(0, item.sh)
        if x + @items.sw > action.sw
          x = [action.sw - @items.sw, 0].max
        end
        if y + @items.sh > action.sh
          y = [action.sh - @items.sh, 0].max
        end
        load_common x, y
      end

      #internal api

      def sketch_behavior

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