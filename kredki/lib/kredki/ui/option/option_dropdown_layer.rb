require_relative 'option_layer'

module Kredki
  module UI
    class OptionDropdownLayer < OptionLayer

      def load! option
        x, y = *option.translate(option.sw, 0)
        if x + @options.sw > action.sw
          x = [x - option.sw - @options.sw, 0].max
        end
        if y + @options.sh > action.sh
          y = [action.sh - @options.sh, 0].max
        end
        load_common x, y
      end

      #internal api

      def sketch p0
        super

        # on_mouse_move! do
        #   parent.layer.update_mouse_location false
        # end
      end

      def set_parent parent
        super and (
          @parent_events&.each{ _1.detach! }
          @parent_events = []


          @parent_events[] = parent.on_focus_gain! do |e|
            load! parent
          end

          @parent_events[] = parent.on_focus_lose! do |e|
            unload! if loaded?
          end

          # @parent_events[] = parent.on_key! :right do |e|
          #   load! parent unless show?
          #   s[Option]&.focus! and e.resolve
          # end

          @parent_events[] = on_key! :left do |e|
            if loaded?
              unload!
              e.resolve
            end
          end
        )
      end

      def grand_pad_detach
        super
        unload! if loaded?
      end
    end
  end
end