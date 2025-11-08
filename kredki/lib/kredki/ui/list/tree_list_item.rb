module Kredki
  module UI
    class TreeListItem < ListItem

      flag def open! value = true, &block
        return if (c = open) == (value = block ? block[c] : value == :not ? !c : value)
        set_open value
        @open = value
        true
      end, def open
        @open || @open.nil?
      end

      flag def dir! value = true, &block
        return if (c = dir) == (value = block ? block[c] : value == :not ? !c : value)
        @dir = value
        update_level
        true
      end

      def item! *a, **na, &b
        parent.item! *a, w: 1r, at: pad_index + 1, level: level + 1, **na, &b
        dir!
      end

      param def level! level
        return if @level == level
        @level = level
        update_level
        true
      end, def level
        @level || 0
      end

      #internal api

      def set_open open
        parent.update_show
      end

      def initialize
        super

        @level_pad = new ShapePad, at: 0, color: 0, h: 1r, w: 16 do
          stroke! color: :text, size: 2, cap: :round, join: :miter
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
              line! w - h * 0.4, h * 0.75
              xy! w - h * 0.4, h * 0.5
              line! w - h * 0.2, h * 0.5
            end
          else
            area! do |w, h|
              xy! w - h * 0.4, h * 0.25
              line! w - h * 0.4, h * 0.75
            end
          end
        end
      end
    end
  end
end
