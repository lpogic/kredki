module Kredki
  module UI
    class Text < Pad
      attr :selection_min, :selection_max, :cursor_position, :cursor

      def sketch p0
        super

        area.hide!
        keyboardy!
    
        on_key! :left do |e|
          cursor_left e.shift?
          e.resolve
        end
    
        on_key! :right do |e|
          cursor_right e.shift?
          e.resolve
        end

        on_key! :home do |e|
          cursor_home e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_seven do |e|
          unless e.num?
            cursor_home e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :end do |e|
          cursor_end e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_one do |e|
          unless e.num?
            cursor_end e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :a do |e|
          if e.ctrl?
            @selection_min = 0
            @selection_max = @cursor_position = string_length
            update_cursor
            e.resolve
          end
        end

        on_key! :c do |e|
          if e.ctrl? && selection?
            clipboard.string = string[@selection_min...@selection_max]
            e.resolve
          end
        end

        on_mouse_button! do |e|
          if keyboard.shift?
            drag e.x, e.y
          else
            cursor_position = self.cursor_position e.x, e.y
            reset_cursor cursor_position
          end
        end

        on_drag! do |e|
          drag e.x, e.y
          e.resolve
        end

        on_drop! do |e|
          @cursor_position = cursor_position e.x, e.y
          e.resolve
        end

        on_click! do |e|
          if e.clicks > 1 && !keyboard.shift?
            @selection_min = 0
            @cursor_position = @selection_max = string_length
            update_cursor
          end
          e.resolve
        end
      end

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

      def selection?
        @selection_min != @selection_max
      end

      def reset_cursor position = 0
        @cursor_position = @selection_min = @selection_max = position
        update_cursor
      end

      def drag x, y
        cursor_position = self.cursor_position x, y
        if cursor_position != @cursor_position
          if @cursor_position == @selection_min
            if cursor_position <= @selection_max
              @selection_min = @cursor_position = cursor_position
            else
              @selection_min = @selection_max
              @selection_max = @cursor_position = cursor_position
            end
          elsif @cursor_position == @selection_max
            if cursor_position >= @selection_min
              @selection_max = @cursor_position = cursor_position
            else
              @selection_max = @selection_min
              @selection_min = @cursor_position = cursor_position
            end
          end
          update_cursor
        end
      end

      def cursor_left shift
        if shift
          if @cursor_position > 0
            if @cursor_position == @selection_min
              @selection_min = @cursor_position -= 1
            elsif @cursor_position == @selection_max
              @selection_max = @cursor_position -= 1
            end
          end
        else
          if @selection_min == @selection_max            
            @cursor_position -= 1 if @cursor_position > 0
            @selection_min = @selection_max = @cursor_position
          else
            @cursor_position = @selection_max = @selection_min
          end
        end
        update_cursor
      end

      def cursor_right shift
        length = string_length
        if shift
          if @cursor_position < length
            if @cursor_position == @selection_max
              @selection_max = @cursor_position += 1
            elsif @cursor_position == @selection_min
              @selection_min = @cursor_position += 1
            end
          end
        else
          if @selection_min == @selection_max            
            @cursor_position += 1 if @cursor_position < length
            @selection_min = @selection_max = @cursor_position
          else
            @cursor_position = @selection_min = @selection_max
          end
        end
        update_cursor
      end

      aliasing def cc! color
        @cursor.color! color
      end, :cc=, :cursor_color!, :cursor_color=

      aliasing def cc
        @cursor.color
      end, :cursor_color

      def autosized?
        true
      end
    end
  end
end