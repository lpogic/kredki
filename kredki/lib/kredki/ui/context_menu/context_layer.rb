module Kredki
  module UI
    class ContextLayer < Layer
      
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

        @items = new ContextPad, out: {w: 1, fill: :dark_gray}
        @item_group = @items.new ContextItemGroup
      end

      def load_common x, y
        @items.xy! x, y
        parent.action.push_layer self
        break_layout
      end

      def sketch_behavior
        super

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