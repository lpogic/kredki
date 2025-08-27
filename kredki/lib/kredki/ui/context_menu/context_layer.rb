module Kredki
  module UI
    class ContextLayer < Layer

      def load_common x, y
        @items.xy! x, y
        parent.action.push_layer self
        break_layout
      end
      
      def unload!
        update_keyboard_pad nil
        pad_detach
      end

      def loaded?
        !!@pad_parent
      end

      attr :items, :item_group

      #internal api

      def initialize
        super

        @items = new ContextPad, stroke: {size: 1, color: :dark_gray}
        @item_group = @items.new ContextItemGroup
      end

      def sketch p0
        super

        driver
      end

      def driver
        on_key! :up, :down do |e|
          e.resolve
        end
      end

      def mouse_down e
      end

      def mouse_up e
      end
    end
  end
end