module Kredki
  module Pads
    module Tree
      # Tree list item model.
      class Item < List::Item

        # Add new item.
        def item! *a, **ka, &b
          lower.item! *a, size_x: 1r, at: pad_index + 1, level: level + 1, **ka, &b
          set_dir
        end

        # Set whether is opened.
        def set_open value = true, &block
          return if (c = open) == (value = block ? block[c] : value == Not ? !c : value)
          @open = value
          lower.update_open
          true
        end

        # See #set_open.
        def open= param
          send_bundle :set_open, param
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

        # Set level.
        def set_level level
          return if @level == level
          @level = level
          update_level
          true
        end

        # See #set_level.
        def level= param
          send_bundle :set_level, param
        end
        
        # Get level
        def level
          @level || 0
        end

        # :section: LEVEL 2

        def initialize
          super

          @level_pad = put SpacePad, at: 0, size_x: 0
        end

        def update_level
          @level_pad.size_x = level * 16
        end

      end#Item
    end#Tree
  end#Pads
end#Kredki
