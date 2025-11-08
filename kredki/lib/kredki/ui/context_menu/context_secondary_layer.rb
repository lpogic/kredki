require_relative 'context_layer'

module Kredki
  module UI
    class ContextSecondaryLayer < ContextLayer

      def load! item
        item.layer&.arrange
        action = parent.action
        x, y = *item.translate(item.sw, 0)
        if x + @items.sw > action.sw
          x = [x - item.sw - @items.sw, 0].max
        end
        if y + @items.sh > action.sh
          y = [action.sh - @items.sh, 0].max
        end
        load_common x, y
      end

      #internal api

      def sketch_behavior
        super
        
        on! Item::PickEvent do |e|
          if e.target.has_subitem?
            e.resolve
          else
            parent.report e
            pad_detach
          end
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
          
          @parent_events[] = on_key! :left do |e|
            if loaded?
              unload!
              e.resolve
            end
          end
        )
      end

      def grand_pad_detach
        super
        unload! if loaded?
      end
    end
  end
end