require_relative 'layer'

module Kredki
  module Pads
    module Context
      # Deeper context layer.
      class SecondaryLayer < Layer

        # :section: LEVEL 2

        def load item
          item.layer&.arrange
          w, h = parent.window.wh
          x, y = *item.translate(item.sw, 0)
          if x + @items.sw > w
            x = [x - item.sw - @items.sw, 0].max
          end
          if y + @items.sh > h
            y = [h - @items.sh, 0].max
          end
          load_common x, y
        end

        def behavior
          super
          
          on Item::PickEvent do |e|
            if e.target.d? Item
              e.close
            else
              parent.report e
              pad_detach
            end
          end
        end

        def set_parent parent, at = nil
          if super
            @parent_events&.each{ _1.detach }
            @parent_events = []

            parent.on_focus_enter do |e|
              load parent
            end.then{|it| @parent_events << it }

            parent.on_focus_leave do |e|
              unload if loaded?
            end.then{|it| @parent_events << it }
            
            on_key_press :left do |e|
              if loaded?
                unload
                e.close
              end
            end.then{ @parent_events << it }

          end
        end

        def grand_pad_detach
          super
          unload if loaded?
        end

      end#SecondaryLayer
    end#Context
  end#Pads
end#Kredki