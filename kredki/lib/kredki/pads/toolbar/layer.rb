module Kredki
  module Pads
    module Toolbar
      # Base class for toolbar layers.
      class Layer < Pads::Layer

        # :section: LEVEL 2

        def initialize
          super

          @context_pad = put Context::Pad, stroke: [1, :dark_gray] do
          scene.drop_shadow color: :black # this is too expensive at the moment
        end
          @item_group = @context_pad.put Context::ItemGroup
        end

        attr :context_pad, :item_group

        def load_common x, y
          @context_pad.set_xy x, y
          lower.pane.push_layer self
          break_layout
        end
        
        def unload
          update_keyboard_pad nil
          pad_detach
        end

        def loaded?
          !!@lower_pad
        end

        def mouse_press e
        end

        def mouse_release e
        end
      end#Layer
    end#Toolbar
  end#Pads
end#Kredki