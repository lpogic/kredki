module Kredki
  module UI
    class TreeListItem < ListItem

      flag :open, nil: true, set: :set_open
      flag :dir, set: :set_dir

      def item! *a, **na, &b
        parent.item! *a, w: 100r, at: pad_index + 1, level: level + 1, **na, &b
        dir!
      end

      def set_dir dir
        @dir = dir
        update_level
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
        @open = open
        parent.update_show
      end

      def initialize
        super

        @_level = new Pad, at: 0, color: 0, h: 100r do
          stroke! color: :text, size: 2, cap: :round, join: :miter
        end
      end

      def sketch p0
        super

        update_level
      end

      def update_level
        l = level
        dir = @dir
        @_level.alter do
          w! (l + 1) * 16
          if dir
            area! do |w, h|
              xy! w - 8, h * 0.3
              line! w - 8, h * 0.7
              xy! w - 8, h * 0.5
              line! w - 3, h * 0.5
            end
          else
            area! do |w, h|
              xy! w - 8, h * 0.3
              line! w - 8, h * 0.7
            end
          end
        end
      end
    end
  end
end
