require_relative 'layer'

module Kredki
  module Pads
    module Context
      # Deeper context layer.
      class SecondaryLayer < Layer

        # :section: LEVEL 2

        def load item
          item.layer&.arrange
          window_sx, window_sy = lower.window.size
          x, y = *item.translate(item.area_size_x, 0)
          if x + @items.area_size_x > window_sx
            x = [x - item.area_size_x - @items.area_size_x, 0].max
          end
          if y + @items.area_size_y > window_sy
            y = [window_sy - @items.area_size_y, 0].max
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
        end

        def set_lower lower, at = nil
          if super
            @lower_events&.each{|it| it.detach }

            focus_enter = lower.on_focus_enter do |e|
              load lower
            end

            focus_leave = lower.on_focus_leave do |e|
              unload if loaded?
            end
            
            left_key_press = on_key_press :left do |e|
              if loaded?
                unload
                e.close
              end
            end

            @lower_events = [focus_enter, focus_leave, left_key_press]
          end
        end

        def grand_detach
          super
          unload if loaded?
        end

      end#SecondaryLayer
    end#Context
  end#Pads
end#Kredki