module Kredki
  module UI
    class TreeListItem < ListItem

      flag def open! s = true
        c, n = open? s
        return if c == n
        set_open n
        @open = n
        true
      end, def open
        @open.nil? || @open
      end

      flag def dir! s = true
        c, n = dir? s
        return if c == n
        @dir = n
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

        @_level = new ShapePad, at: 0, color: 0, h: 1r, w: 16 do
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
