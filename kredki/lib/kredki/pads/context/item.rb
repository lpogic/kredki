require_relative '../item/item_y'

module Kredki
  module Pads
    module Context
      class Item < ItemY

        # Add new item.
        def item!(...)
          item_layer = dropdown!
          item = item_layer.item_group.item!(...)
          item_layer.load self if keyboard_top && !item_layer.loaded
          item
        end

        # Create/Update dropdown layer.
        def dropdown! ...
          (upper(SecondaryLayer) or dropdown_enable).set(...)
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @start = put SpacePad, size: Kredki.text_size
          @end = put SpacePad, size: Kredki.text_size, x: End
        end

        def behavior
          super

          on_key_press :right do |e|
            layer = upper SecondaryLayer
            if layer
              layer.load self
              layer[Item]&.keyboard_request and e.close
            end
          end
        end

        def mouse_enter e
          super
          layer = upper SecondaryLayer
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

        def dropdown_disable
          @end.clear
          se;f[SecondaryLayer]&.detach
        end

        def default_text text
          put TextPad, text, mousy: false, at: 1
        end
        
      end#Item
    end#Context
  end#Pads
end#Kredki
