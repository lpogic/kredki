module Kredki
  module Pads
    module Context
      # Base class for context layers.
      class Layer < Pads::Layer

        # :section: LEVEL 2

        def unload
          update_keyboard_pad nil
          pad_detach
        end

        def loaded?
          !!@lower_pad
        end

        attr :items, :item_group

        def initialize
          super

          @items = put Pad, outline: [1, :dark_gray] do
            scene.drop_shadow color: :black
          end
          @item_group = @items.put ItemGroup
        end

        def load_common x, y
          @items.set_xy x, y
          lower.pane.push_layer self
          break_layout
        end

        def behavior
          super

          on_key :up, :down do |e|
            e.close
          end
        end

        def mouse_press e
        end

        def mouse_release e
        end
      end#Layer
    end#Context
  end#Pads
end#Kredki