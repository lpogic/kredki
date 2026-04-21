require_relative 'layer'

module Kredki
  module Pads
    module Context
      class PrimaryLayer < Layer

        # :section: LEVEL 2

        def load x, y
          arrange
          window_sx, window_sy = lower.window.size
          x_max = window_sx - @items.area_size_x
          x = [x_max, 0].max if x > x_max
          sy = @items.area_size_y
          y = [y - sy, 0].max if y + sy > window_sy
          load_common x, y
        end

        def behavior
          super

          on_key_press :escape do |e|
            pad_detach
            e.close
          end

          on_mouse_press do |e|
            pad_detach
          end

        end

        def mouse_enter e
          super
          e.close
        end

        def mouse_leave e
          super
          e.close
        end

        def mouse_move e
          super
          e.close
        end

      end#PrimaryLayer
    end#Context
  end#Pads
end#Kredki