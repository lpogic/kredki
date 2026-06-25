module Kredki
  module Pads
    module Resizable
      class XHandle < Pad

        # :section: LEVEL 2

        def sketch
          super 

          set_layoutic false
          set_xy End, Start
          set_size 8, 1r
          set_mouse_cursor :resize_x
        end

        def behavior
          super

          on_mouse_move do |event|
            if event.drag?
              resizable = lower ResizablePad
              x = pane.translate_x event.x, resizable
              resizable.set_size_x [0, x].max
            end
          end
        end

        def drag_check bxy, xy
          (bxy[0] - xy[0]).abs > 0
        end

      end#XHandle
    end#Resizable
  end#Pads
end#Kredki
