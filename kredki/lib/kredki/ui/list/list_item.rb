module Kredki
  module UI
    class ListItem < YItem
      extend HasEventResolvers


      class ColorTheme < Theme
        model :color

        def attach! pad
          super pad, [
            pad.on_focus_enter!,
            pad.on_focus_leave!,
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!,
          ]
        end

        def repaint
          @pad.area.fill_color = @pad.select? ? :text_selection : @pad.mouse_in? ? @color.lighten : @color
          if @pad.keyboard_in?
            @pad.area.stroke_size = 1
            @pad.area.stroke_color = :stroke_focus
          else
            @pad.area.stroke_size = 0
            @pad.area.stroke_color = @color
          end
        end
      end

      def color_theme color
        ColorTheme.new color
      end

      flag def select! s = true
        c, n = select? s
        return if c == n
        @select = n
        @theme.repaint
        true
      end

      #internal api

      def sketch p0
        super
        
        on_key_down! :up do |e|
          select! if e.shift?
          item = parent.update_select_item(:previous)
          if item
            item.select! if e.shift?
            item.roi!
          end
          e.resolve
        end

        on_key_down! :down do |e|
          select! if e.shift?
          item = parent.update_select_item(:next)
          if item
            item.select! if e.shift?
            item.roi!
          end
          e.resolve
        end
      end

      def mouse_enter e
      end

      def mouse_down e
        parent.select_up_to self if keyboard.then{ it.shift? && !it.ctrl? }
        super
      end

      def min_w
        @text.fit_w
      end

    end
  end
end
