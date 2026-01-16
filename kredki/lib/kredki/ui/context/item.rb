require_relative '../text_pad'
require_relative '../item/y_item'

module Kredki
  module UI
    module Context
      class Item < YItem

        # Add new item.
        def item!(...)
          dropdown!.item_group.item!(...)
        end

        # Create/Update dropdown layer.
        def dropdown! ...
          fc SecondaryLayer or begin
            fc(:end_icon).scenic!
            new SecondaryLayer
          end.alter(...)
        end

        # :section: LEVEL 2

        def initialize
          super
          
          new SpacePad, h: 1r, w: :h
          new TextPad, "", mousy: false
          new RectanglePad, :end_icon, mousy: false, keyboardy: false, fill: 0, x: :end, h: 1r, w: :h do
            outline! fill: :text, w: 2, cap: :round
            area! do |w, h|
              xy! w * 0.5, h * 0.35
              line! w * 0.65, h * 0.5
              line! w * 0.5, h * 0.65
            end
            scenic! false
          end
        end

        def behavior
          super

          on_key_press :right do |e|
            fc(SecondaryLayer)&.then do
              it.load self unless it.loaded?
              it.fd(Item)&.keyboard_request and e.close
            end
          end

        end

        def mouse_enter e
          super
          fd(SecondaryLayer)&.then{ it.update_keyboard_pad nil if it.loaded? }
        end
        
      end#Item
    end#Context
  end#UI
end#Kredki
