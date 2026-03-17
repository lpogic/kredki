module Kredki
  module Pads
    module Toolbar
      # Basic toolbar layer.
      class PrimaryLayer < Layer

        # :section: LEVEL 2

        def load item
          arrange
          wsx, wsy = lower.window.size
          x, y = *item.translate(0, item.area_size_y)
          if x + @context_pad.area_size_x > wsx
            x = [wsc - @context_pad.area_size_x, 0].max
          end
          if y + @context_pad.area_size_y > wsy
            y = [wsy - @context_pad.area_size_y, 0].max
          end
          load_common x, y
        end

        def behavior
          super

          on Item::PickEvent do |e|
            if e.target.find_upper Item
              e.close
            else
              lower.report e
              pad_detach
            end
          end
        
          on_key :escape do |e|
            pad_detach
            e.close
          end

          on_mouse_press do |e|
            pad_detach
          end
        end

        def update_lower lower, at = nil
          if super
            @lower_events&.each{ _1.detach }
            @lower_events = []


            focus_enter = lower.on_focus_enter do |e|
              load lower
            end

            focus_leave = lower.on_focus_leave do |e|
              unload if loaded?
            end
            
            @lower_events = [focus_enter, focus_leave]
          end
        end
      end#PrimaryLayer
    end#Toolbar
  end#Pads
end#Kredki