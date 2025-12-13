module Kredki
  module UI
    module Toolbar
      # Base class for toolbar layers.
      class Layer < UI::Layer

        # :section: LEVEL 2

        def initialize
          super

          @items = new Context::Pad, out: {w: 1, fill: :dark_gray}
          @item_group = @items.new Context::Group
        end

        attr :items, :item_group

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

        def mouse_down e
        end

        def mouse_up e
        end
      end#Layer
    end#Toolbar
  end#UI
end#Kredki