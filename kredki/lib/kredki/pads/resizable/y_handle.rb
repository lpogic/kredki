module Kredki
  module Pads
    module Resizable
      class YHandle < Pad

        # :section: LEVEL 2

        def sketch
          super 

          set_layoutic false
          set_xy Start, End
          set_size 1r, 8
          set_mouse_cursor :resize_y
        end

        def behavior
          super

          on_mouse_move do |event|
            if event.drag?
              resizable = lower ResizablePad
              y = pane.translate_y event.y, resizable
              resizable.set_size_y [0, y].max
            end
          end
        end

        def drag_check bxy, xy
          (bxy[1] - xy[1]).abs > 0
        end

      end#YHandle
    end#Resizable
  end#Pads
end#Kredki
