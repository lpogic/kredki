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
          (c? PrimaryLayer or new PrimaryLayer).alter(...)
        end

        # See #dropdown!.
        def dropdown= param
          send_bundle :dropdown!, param
        end

        # Get dropdown.
        def dropdown
          c? PrimaryLayer
        end

        # Set whether is directory.
        def dir! value = true, set_icon = true, &block
          return if (c = dir) == (value = block ? block[c] : value == Not ? !c : value)
          @dir = value
          true
        end

        # See #dir!.
        def dir= param
          send_bundle :dir!, param
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

          mx! 5
        end

        def behavior
          super

          on_key_press :down, :up, :enter, :space do |e|
            c?(PrimaryLayer)&.then do |it|
              it.load self unless it.loaded?
              it.d?(Context::Item)&.keyboard_request and e.close
            end
          end

          on_mouse_click do |e|
            d?(PrimaryLayer)&.then{|it| it.load self unless it.loaded? }
          end
        end

        def mouse_enter e
          super
          d?(PrimaryLayer)&.then{|it| it.update_keyboard_pad nil if it.loaded? }
        end

      end#Item
    end#Toolbar
  end#Pads
end#Kredki
