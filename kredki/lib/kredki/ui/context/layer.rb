module Kredki
  module UI
    module Context
      # Base class for context layers.
      class Layer < UI::Layer

        # :section: LEVEL 2

        def unload
          update_keyboard_pad nil
          pad_detach
        end

        def loaded?
          !!@pad_parent
        end

        attr :items, :item_group

        def initialize
          super

          @items = new Pad, outline: [1, :dark_gray]
          @item_group = @items.new ItemGroup
        end

        def load_common x, y
          @items.xy! x, y
          parent.window.push_layer self
          break_layout
        end

        def behavior
          super

          on_key! :up, :down do |e|
            e.resolve
          end
        end

        def mouse_press e
        end

        def mouse_free e
        end
      end#Layer
    end#Context
  end#UI
end#Kredki