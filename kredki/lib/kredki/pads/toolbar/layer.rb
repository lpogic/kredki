module Kredki
  module Pads
    module Toolbar
      # Base class for toolbar layers.
      class Layer < Pads::Layer

        # :section: LEVEL 2

        def initialize
          super

          @context_pad = new Context::Pad, outline: [1, :dark_gray] do
          scene.drop_shadow! color: :black
        end
          @item_group = @context_pad.new Context::ItemGroup
        end

        attr :context_pad, :item_group

        def load_common x, y
          @context_pad.xy! x, y
          parent.window.push_layer self
          break_layout
        end
        
        def unload
          update_keyboard_pad nil
          pad_detach
        end

        def loaded?
          !!@pad_parent
        end

        def mouse_press e
        end

        def mouse_release e
        end
      end#Layer
    end#Toolbar
  end#Pads
end#Kredki