module Kredki
  module UI
    class ToolbarLayer < Layer

      def load_common x, y
        @options.xy! x, y
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

      attr :options, :option_group

      #internal api

      def initialize
        super

        @options = new ContextPad, stroke: {size: 1, color: :dark_gray}
        @option_group = @options.new ContextOptionGroup
      end

      def mouse_down e
      end

      def mouse_up e
      end
    end
  end
end