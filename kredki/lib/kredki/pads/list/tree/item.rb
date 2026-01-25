module Kredki
  module Pads
    module Tree
      # Tree list item model.
      class Item < List::Item

        # Add new item.
        def item! *a, **na, &b
          parent.item! *a, w: 1r, at: pad_index + 1, level: level + 1, **na, &b
          dir!
        end

        # Set whether is opened.
        def open! value = true, &block
          return if (c = open) == (value = block ? block[c] : value == :not ? !c : value)
          @open = value
          parent.update_show
          true
        end

        # See #open!.
        def open= param
          send_ahp :open!, param
        end

        # Get whether is opened.
        def open
          @open || @open.nil?
        end

        # See #open.
        def open?
          !!open
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

        # Set level.
        def level! level
          return if @level == level
          @level = level
          update_level
          true
        end

        # See #level!.
        def level= param
          send_ahp :level!, param
        end
        
        # Get level
        def level
          @level || 0
        end

        # :section: LEVEL 2

        def initialize
          super

          @level_pad = new SpacePad, at: 0, w: 0
        end

        def update_level
          @level_pad.w = level * 16
        end

      end#Item
    end#Tree
  end#Pads
end#Kredki
