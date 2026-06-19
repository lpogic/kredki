module Kredki
  module Pads
    module Accordion
      class YHandle < RectanglePad

        feature :accord_before
        feature :accord_after

        # :section: LEVEL 2

        def sketch
          super 

          set_layoutic false
          set_xy Start, :end_center
          set_size 1r, 8
          set_fill false
          set_mouse_cursor :resize_y
        end

        def behavior
          super

          on_mouse_move do |event|
            if event.drag?
              by = pane.translate_y event.y, @accord_before
              ay = @accord_after.area_size_y - pane.translate_y(event.y, @accord_after)
              if by >= 0 && ay >= 0
                accordion = lower Accordion::YAccordion
                accordion_size = accordion.area_size_y
                total_size = @accord_before.area_size_y + @accord_after.area_size_y
                bsy = @accord_before.get_size_y_limited by, @accord_before.size_y_limit, accordion_size
                asy = @accord_after.get_size_y_limited total_size - bsy, @accord_after.size_y_limit, accordion_size
                if bsy + asy == total_size
                  @accord_before.set_size_y bsy
                  @accord_after.set_size_y asy
                else
                  asy = @accord_after.get_size_y_limited ay, @accord_after.size_y_limit, accordion_size
                  bsy = @accord_before.get_size_y_limited total_size - asy, @accord_before.size_y_limit, accordion_size
                  if bsy + asy == total_size
                    @accord_before.set_size_y bsy
                    @accord_after.set_size_y asy
                  end
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
