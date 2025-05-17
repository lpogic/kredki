require_relative 'option_layer'

module Kredki
  module UI
    class ContextLayer < OptionLayer

      def load! x, y
        x_max = action.w - @options.sw 
        x = [x_max, 0].max if x > x_max
        sh = @options.sh
        y = [y - sh, 0].max if y + sh > action.h
        load_common x, y
      end

      def on_pick! ...
        on!(Option::PickEvent, ...)
      end

      #internal api

      def sketch p0
        super

        on! Option::PickEvent, aim: true do |e|
          if e.target.dropdown
            e.resolve
          else
            detach!
          end
        end

        on_key! :escape do |e|
          detach!
          e.resolve
        end

        on_mouse_button_down! do |e|
          detach!
        end
      end

      def set_parent parent
        super and (
          @parent_events&.each{ _1.detach! }
          @parent_events = []

          @parent_events[] = parent.on_mouse_button! :secondary do |e|
            load! *parent.translate(*e.xy)
            s[Option]&.focus!
            e.resolve
          end
    
          @parent_events[] = parent.on_key! :context do |e|
            load! *parent.translate(parent.sw / 2, parent.sh / 2)
            s[Option]&.focus!
            e.resolve
          end
        )
      end
    end
  end
end