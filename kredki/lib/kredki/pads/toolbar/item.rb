require_relative '../item/item_x'

module Kredki
  module Pads
    module Toolbar
      class Item < Pads::ItemX

        # Add submenu item.
        def item!(...)
          item_layer = dropdown!
          item = item_layer.item_group.item!(...)
          item_layer.load self if keyboard_top && !item_layer.loaded
          item
        end

        # Create/Update dropdown.
        def dropdown! ...
          (find PrimaryLayer or put PrimaryLayer).set(...)
        end

        # See #dropdown!.
        def dropdown= param
          send_bundle :dropdown!, param
        end

        # Get dropdown.
        def dropdown
          find PrimaryLayer
        end

        # :section: LEVEL 2

        def sketch
          super

          set_margin_x 5
        end

        def behavior
          super

          on_key_press :down, :up, :enter, :space do |e|
            layer = find PrimaryLayer
            if layer
              layer.load self unless layer.loaded
              layer.find_upper(Context::Item)&.keyboard_request and e.close
            end
          end

          on_mouse_click do |e|
            layer = find_upper PrimaryLayer
            layer.load self if layer && !layer.loaded
          end
        end

        def mouse_enter e
          super
          layer = find_upper PrimaryLayer
          layer.update_keyboard_pad nil if layer&.loaded
        end

      end#Item
    end#Toolbar
  end#Pads
end#Kredki
