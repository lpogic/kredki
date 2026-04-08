require_relative '../item/x_item'

module Kredki
  module Pads
    module Toolbar
      class Item < Pads::XItem

        # Add submenu item.
        def item!(...)
          dropdown!.item_group.item!(...)
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

        # Set whether is directory.
        def set_dir value = true, set_icon = true, &block
          return if (c = dir) == (value = block ? block[c] : value == Not ? !c : value)
          @dir = value
          true
        end

        # See #set_dir.
        def dir= param
          send_bundle :set_dir, param
        end

        # Get whether is directory.
        def dir
          @dir
        end

        # See #dir.
        def dir?
          !!dir
        end

        # :section: LEVEL 2

        def sketch
          super

          set_margin_x 5
        end

        def behavior
          super

          on_key_press :down, :up, :enter, :space do |e|
            if layer = find PrimaryLayer
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
