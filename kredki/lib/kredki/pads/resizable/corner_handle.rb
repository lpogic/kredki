module Kredki
  module Pads
    module Resizable
      class CornerHandle < Pad

        # :section: LEVEL 2

        def sketch
          super 

          set_layoutic false
          set_xy End
          set_size 8
          set_area do |x, y|
              jump x - 2, 0
              line x - 2, y - 2
              line 0, y - 2
            end
          set_mouse_cursor :resize_ee
        end

        def behavior
          super

          on_mouse_move do |event|
            if event.drag?
              resizable = lower ResizablePad
              x, y = pane.translate *event.xy, resizable
              resizable.set_size [0, x].max, [0, y].max
            end
          end
        end

        def drag_check bxy, xy
          (bxy[0] - xy[0]).abs > 0
        end

      end#CornerHandle
    end#Resizable
  end#Pads
end#Kredki
