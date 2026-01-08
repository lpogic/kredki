require_relative '../text_pad'
require_relative '../item/x_item'

module Kredki
  module UI
    module Toolbar
      class Item < UI::XItem

        # Add submenu item.
        def item!(...)
          dropdown!.item_group.item!(...)
        end

        # Create/Update dropdown.
        def dropdown! ...
          (fc PrimaryLayer or new PrimaryLayer).alter(...)
        end

        # See #dropdown!.
        def dropdown= param
          send_ahp :dropdown!, param
        end

        # Get dropdown.
        def dropdown
          fc PrimaryLayer
        end

        # Set whether is directory.
        def dir! value = true, set_icon = true, &block
          return if (c = dir) == (value = block ? block[c] : value == :not ? !c : value)
          @dir = value
          true
        end

        # See #dir!.
        def dir= param
          send_ahp :dir!, param
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

          margin_x! 5
        end

        def behavior
          super

          on_key_press! :down, :up, :enter, :space do |e|
            fc(PrimaryLayer)&.then do
              it.load self unless it.loaded?
              it.fd(Context::Item)&.keyboard_request and e.resolve
            end
          end

          on_mouse_click! do |e|
            fd(PrimaryLayer)&.then{ it.load self unless it.loaded? }
          end
        end

        def mouse_enter e
          super
          fd(PrimaryLayer)&.then{ it.update_keyboard_pad nil if it.loaded? }
        end

      end#Item
    end#Toolbar
  end#UI
end#Kredki
