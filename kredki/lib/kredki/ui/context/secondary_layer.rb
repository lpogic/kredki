require_relative 'layer'

module Kredki
  module UI
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
          
          on! Item::PickEvent do |e|
            if e.target.fd Item
              e.resolve
            else
              parent.report e
              pad_detach
            end
          end
        end

        def set_parent parent, at = nil
          if super
            @parent_events&.each{ _1.detach! }
            @parent_events = []

            @parent_events.push = parent.on_focus_enter! do |e|
              load parent
            end

            @parent_events.push = parent.on_focus_leave! do |e|
              unload if loaded?
            end
            
            @parent_events.push = on_key_press! :left do |e|
              if loaded?
                unload
                e.resolve
              end
            end
          end
        end

        def grand_pad_detach
          super
          unload if loaded?
        end

      end#SecondaryLayer
    end#Context
  end#UI
end#Kredki