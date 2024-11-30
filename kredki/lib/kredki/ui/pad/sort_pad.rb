module Kredki
  module UI
    class SortPad < Pad

      #internal api

      def sketch p0
        super

        area.hide!
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          return true if @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads }
          pads >> 1
        end
        return false
      end

    end
  end
end