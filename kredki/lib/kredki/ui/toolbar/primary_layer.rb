module Kredki
  module UI
    module Toolbar
      # Basic toolbar layer.
      class PrimaryLayer < Layer

        # :section: LEVEL 2

        def load item
          arrange
          w, h = parent.window.wh
          x, y = *item.translate(0, item.sh)
          if x + @context_pad.sw > w
            x = [w - @context_pad.sw, 0].max
          end
          if y + @context_pad.sh > h
            y = [h - @context_pad.sh, 0].max
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
        
          on_key! :escape do |e|
            pad_detach
            e.resolve
          end

          on_mouse_press! do |e|
            pad_detach
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
          end
        end
      end#PrimaryLayer
    end#Toolbar
  end#UI
end#Kredki