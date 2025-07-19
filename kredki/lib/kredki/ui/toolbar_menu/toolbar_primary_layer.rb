module Kredki
  module UI
    class ToolbarPrimaryLayer < ToolbarLayer

      def load! option
        arrange
        action = parent.action
        x, y = *option.translate(0, option.sh)
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

        on! Option::PickEvent do |e|
          if e.target.has_suboption?
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

        on_mouse_down! do |e|
          pad_detach
        end
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
        )
      end

      # def mouse_enter e
      #   super
      #   e.resolve
      # end

      # def mouse_leave e
      #   super
      #   e.resolve
      # end

      # def mouse_move e
      #   super
      #   e.resolve
      # end
    end
  end
end