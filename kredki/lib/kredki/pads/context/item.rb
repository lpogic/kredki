require_relative '../item/item_y'

module Kredki
  module Pads
    module Context
      class Item < ItemY

        # Add new item.
        def item!(...)
          dropdown!.item_group.item!(...)
        end

        # Create/Update dropdown layer.
        def dropdown! ...
          (find SecondaryLayer or dropdown_enable).set(...)
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @start = put SpacePad, size: [:y, 1r]
          @end = put SpacePad, size: [:y, 1r], x: End
        end

        def behavior
          super

          on_key_press :right do |e|
            layer = find SecondaryLayer
            if layer
              layer.load self
              layer.find_upper(Item)&.keyboard_request and e.close
            end
          end

        end

        def mouse_enter e
          super
          layer = find SecondaryLayer
          layer.update_keyboard_pad nil if layer&.loaded
        end

        def dropdown_enable
          @end.put RectanglePad, mousy: false, keyboardy: false, fill: 0, size: 1r do
            set_stroke fill: :text, width: 2, cap: :round
            set_area do |sx, sy|
              jump sx * 0.5, sy * 0.35
              line sx * 0.65, sy * 0.5
              line sx * 0.5, sy * 0.65
            end
          end
          put SecondaryLayer
        end

        def default_text text
          put TextPad, text, mousy: false, at: 1
        end
        
      end#Item
    end#Context
  end#Pads
end#Kredki
