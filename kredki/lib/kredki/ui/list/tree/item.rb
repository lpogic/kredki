module Kredki
  module UI
    module Tree
      # Tree list item model.
      class Item < List::Item

        # Add new item.
        def item! *a, **na, &b
          o = parent.item! *a, w: 1r, at: pad_index + 1, level: level + 1, **na, &b
          dir!
        end

        # Set whether is opened
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
        def dir! value = true, &block
          return if (c = dir) == (value = block ? block[c] : value == :not ? !c : value)
          @dir = value
          update_level
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

          @level_pad = new RectanglePad, at: 0, fill: 0, h: 1r, w: 16 do
            outline! fill: :text, w: 2, cap: :round
          end
        end

        def sketch
          super

          update_level
        end

        def update_level
          l = level
          dir = @dir
          @level_pad.alter do
            w! (l + 1) * 16
            if dir
              area! do |w, h|
                xy! w - h * 0.4, h * 0.25
                line! w - h * 0.4, h * 0.35
                line! w - h * 0.2, h * 0.5
                line! w - h * 0.4, h * 0.65
                line! w - h * 0.4, h * 0.75
              end
            else
              area! do |w, h|
                xy! w - h * 0.4, h * 0.25
                line! w - h * 0.4, h * 0.75
              end
            end
          end
        end

      end#Item
    end#Tree
  end#UI
end#Kredki
