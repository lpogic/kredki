module Kredki
  module UI
    class Label < Pad

      def sketch p0
        super

        body.color = :transparent

        @cursor_position = @selection_min = @selection_max = 0

        selection = rectangle! x: 0, y: 0, w: 0, color: :blue do
          clip! p0.body
        end

        text = text! x: 0, y: 0, color: :white, font: :arial, h: 30

        p0.h = text.h

        on_resize! do
          selection.h = h
        end.resolve
    
        @update_cursor = proc do
          x = text.substring_width @cursor_position
          if @selection_min == @selection_max
            selection.w = 0
          else
            if @selection_min == @cursor_position
              x1 = text.substring_width @selection_max
              selection.x = text.x + x
              selection.w = x1 - x
            else
              x1 = text.substring_width @selection_min
              selection.x = text.x + x1
              selection.w = x - x1
            end
          end
        end
    
        on_key! :left do |e|
          if e.shift?
            if @cursor_position > 0 && @cursor_position == @selection_min
              @selection_min = @cursor_position -= 1
            elsif @cursor_position == @selection_max
              @selection_max = @cursor_position -= 1
            end
          else
            if @selection_min == @selection_max            
              @cursor_position -= 1 if @cursor_position > 0
              @selection_min = @selection_max = @cursor_position
            else
              @cursor_position = @selection_max = @selection_min
            end
          end
          @update_cursor.call
        end
    
        on_key! :right do |e|
          str = text.string
          if e.shift?
            if @cursor_position < str.length && @cursor_position == @selection_max
              @selection_max = @cursor_position += 1
            elsif @cursor_position == @selection_min
              @selection_min = @cursor_position += 1
            end
          else
            if @selection_min == @selection_max            
              @cursor_position += 1 if @cursor_position < str.length
              @selection_min = @selection_max = @cursor_position
            else
              @cursor_position = @selection_min = @selection_max
            end
          end
          @update_cursor.call
        end

        on_key! :c do |e|
          if e.ctrl? && @selection_min != @selection_max
            clipboard.string = text.string[@selection_min...@selection_max]
          end
        end

        on_mouse_button! do |e|
          cursor_position = text.nearest_character_index e.x - x
          if keyboard.shift?
            if cursor_position < @cursor_position
              @selection_min = cursor_position
              @selection_max = @cursor_position
            else
              @selection_max = cursor_position
              @selection_min = @cursor_position
            end
          else
            @selection_min = @selection_max = @cursor_position = cursor_position
          end
          @update_cursor.call
        end

        on_drag! do |e|
          cursor_position = text.nearest_character_index e.x - x
          if cursor_position + @cursor_position != @selection_min + @selection_max
            if cursor_position < @cursor_position
              @selection_min = cursor_position
              @selection_max = @cursor_position
            else
              @selection_max = cursor_position
              @selection_min = @cursor_position
            end
            @update_cursor.call          
          end
        end

        on_drop! do |e|
          @cursor_position = text.nearest_character_index e.x - x
        end

        on_click! do |e|
          if e.clicks > 1
            @selection_min = 0
            @cursor_position = @selection_max = text.string.length
            @update_cursor.call
            clipboard.string = text.string if e.clicks == 3
          end
        end

        on_focus_lose! do
          if @selection_min != @selection_max
            @selection_min = @selection_max = @cursor_position
            @update_cursor.call
          end
        end

        @text = text
      end

      aliasing def s! str
        @text.string != str && begin
          @text.string = str
          w! @text.substring_width.ceil
          @selection_min = @selection_max = @cursor_position = 0
          @update_cursor.call
          report ResizeEvent.new
          true
        end
      end, :s=, :string!, :string=

      aliasing def s
        @text.string
      end, :string

      def_delegators :@text,
        :color, :color!, :color=

      def autosized?
        true
      end
    end
  end
end