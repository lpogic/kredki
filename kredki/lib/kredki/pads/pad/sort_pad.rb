module Kredki
  module Pads
    class SortPad < Pad

      # :section: LEVEL 2

      def point_pads x, y, pads, force = false
        if force || (mousy && scenic && include_point(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          return true if @pads.reverse_each.find{ _1.point_pads x - _1.sx, y - _1.sy, pads }
          pads.pop
        end
        return false
      end
    end
  end
end