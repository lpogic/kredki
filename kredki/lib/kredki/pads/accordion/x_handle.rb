module Kredki
  module Pads
    module Accordion
      class XHandle < RectanglePad

        feature :accord_before
        feature :accord_after

        # :section: LEVEL 2

        def sketch
          super 

          set_layoutic false
          set_xy :end_center, Start
          set_size 8, 1r
          set_fill false
          set_mouse_cursor :resize_x
        end

        def behavior
          super

          on_mouse_move do |event|
            if event.drag?
              bx = [pane.translate_x(event.x, @accord_before), 0].max
              ax = [@accord_after.area_size_x - pane.translate_x(event.x, @accord_after), 0].max
              accordion = lower Accordion::XAccordion
              accordion_size = accordion.area_size_x
              total_size = @accord_before.area_size_x + @accord_after.area_size_x
              bsx = @accord_before.get_size_x_limited bx, @accord_before.size_x_limit, accordion_size
              asx = @accord_after.get_size_x_limited total_size - bsx, @accord_after.size_x_limit, accordion_size
              if bsx + asx == total_size
                @accord_before.set_size_x bsx
                @accord_after.set_size_x asx
              else
                asx = @accord_after.get_size_x_limited ax, @accord_after.size_x_limit, accordion_size
                bsx = @accord_before.get_size_x_limited total_size - asx, @accord_before.size_x_limit, accordion_size
                if bsx + asx == total_size
                  @accord_before.set_size_x bsx
                  @accord_after.set_size_x asx
                end
              end
            end
          end
        end

        def drag_check bxy, xy
          (bxy[0] - xy[0]).abs > 0
        end

      end#Handle
    end#Accordion
  end#Pads
end#Kredki
