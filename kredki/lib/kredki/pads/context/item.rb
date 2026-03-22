require_relative '../item/y_item'

module Kredki
  module Pads
    module Context
      class Item < YItem

        # Add new item.
        def item!(...)
          dropdown!.item_group.item!(...)
        end

        # Create/Update dropdown layer.
        def dropdown! ...
          find SecondaryLayer or begin
            find(:end_icon).set_scenic
            put SecondaryLayer
          end.set(...)
        end

        # :section: LEVEL 2

        def initialize
          super
          
          put SpacePad, size: [:y, 1r]
          put TextPad, "", mousy: false
          put RectanglePad, :end_icon, mousy: false, keyboardy: false, fill: 0, x: End, size: [:y, 1r] do
            set_stroke fill: :text, width: 2, cap: :round
            set_area do |sx, sy|
              jump sx * 0.5, sy * 0.35
              line sx * 0.65, sy * 0.5
              line sx * 0.5, sy * 0.65
            end
            set_scenic false
          end
        end

        def behavior
          super

          on_key_press :right do |e|
            if layer = find_upper SecondaryLayer
              layer.load self if layer.loaded?
              layer.find_upper(Item)&.keyboard_request and e.close
            end
          end

        end

        def mouse_enter e
          super
          layer = find_upper SecondaryLayer
          layer.update_keyboard_pad nil if layer&.loaded?
        end
        
      end#Item
    end#Context
  end#Pads
end#Kredki
