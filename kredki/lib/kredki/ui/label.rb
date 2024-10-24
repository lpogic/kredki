module Kredki
  module UI
    class Label < Pad

      def initialize
        super

        Label.init_flags self
      end

      def sketch p0
        super

        body.hide!
        keyboardy!

        @cursor_position = @selection_min = @selection_max = 0

        @selection = rectangle! x: 0, y: 0, w: 0, color: :blue do
          clip! p0.body
        end

        @text = text! x: 0, y: 0, color: :white, font: :arial, h: 30 do
          clip! p0.body
        end

        @cursor = rectangle! x: 0, y: 0, color: :black, w: 2

        p0.wh = @text.wh

        on_resize! do |e|
          @selection.h = h
          @cursor.h = h
        end.resolve ResizeEvent.new
    
        on_key! :left do |e|
          cursor_left e.shift?
          e.resolve
        end
    
        on_key! :right do |e|
          cursor_right e.shift?
          e.resolve
        end

        on_key! :home do |e|
          cursor_home e.shift?
          e.resolve
        end

        on_key! :keypad_seven do |e|
          unless e.num?
            cursor_home e.shift? 
            e.resolve
          end
        end

        on_key! :end do |e|
          cursor_end e.shift?
          e.resolve
        end

        on_key! :keypad_one do |e|
          unless e.num?
            cursor_end e.shift?
            e.resolve
          end
        end

        on_key! :a do |e|
          if e.ctrl?
            @selection_min = 0
            @selection_max = @cursor_position = @text.string.length
            update_cursor true
            e.resolve
          end
        end

        on_key! :c do |e|
          if e.ctrl? && selection?
            clipboard.string = @text.string[@selection_min...@selection_max]
            e.resolve
          end
        end

        on_mouse_button! do |e|
          if keyboard.shift?
            drag e.x
          else
            cursor_position = text.nearest_character_index e.x - @text.x
            reset_cursor cursor_position, true, true
          end
          e.resolve
        end

        on_drag! do |e|
          drag e.x
          e.resolve
        end

        on_drop! do |e|
          @cursor_position = text.nearest_character_index e.x - @text.x
          e.resolve
        end

        on_click! do |e|
          if e.clicks > 1 && !keyboard.shift?
            @selection_min = 0
            @cursor_position = @selection_max = text.string.length
            @selection.w = @text.w
            @selection.x = @text.x
            @cursor.hide!
          end
          e.resolve
        end

        on_scroll! do |e|
          if keyboard_top?
            # scroll e.xory
            # drag mouse.x if mouse.down?
          end
        end


        on_focus_lose! do |e|
          @cursor.hide!
          # @selection.hide!
          e.resolve
        end.resolve FocusLoseEvent.new

        on_focus_gain! do |e|
          @selection.show!
          @cursor.show!
          e.resolve
        end
      end

      attr :text, :selection_min, :selection_max, :cursor_position

      def << arg
        case arg
        when String
          s! arg
        else
          super
        end
      end

      def selection?
        @selection_min != @selection_max
      end

      def update_cursor move = false, show = true
        @cursor.show! if show
        x = @text.substring_width @cursor_position
        if move
          if @text.x + x > w
            @cursor.x = w - 1
            @text.x = w - x
          elsif @text.x + x < 0
            @cursor.x = -1
            @text.x = -x
          else
            @cursor.x = @text.x + x - 1
          end
        else
          if x <= w
            @cursor.x = x - 1
            @text.x = 0
          elsif @text.x + x < w && @text.x + x > 0
            @cursor.x = @text.x + x - 1
          else
            @cursor.x = w / 2 - 1
            @text.x = w / 2 - x
          end
        end
        if @selection_min == @selection_max
          @selection.w = 0
        else
          if @selection_min == @cursor_position
            x1 = @text.substring_width @selection_max
            @selection.x = @text.x + x
            @selection.w = x1 - x
          else
            x1 = @text.substring_width @selection_min
            @selection.x = @text.x + x1
            @selection.w = x - x1
          end
        end
      end

      def reset_cursor position = 0, move = false, show = false
        @cursor_position = @selection_min = @selection_max = position
        update_cursor move, show
      end

      def scroll move
        offset = 0
        if move > 0
          if @text.x < 0
            offset = [@text.x + move * @text.h, 0].min - @text.x
          end
        elsif move < 0
          min_text_x = w - @text.w
          if @text.x > min_text_x
            offset = @text.x - [@text.x - move * @text.h, min_text_x].max
          end
        end
        if offset != 0
          @text.x += offset
          @selection.x += offset if selection?
          @cursor.hide!
        end
      end

      def drag x
        cursor_position = text.nearest_character_index x - @text.x
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
          update_cursor true
        end
      end

      def cursor_left shift
        if shift
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
        update_cursor true
      end

      def cursor_right shift
        str = text.string
        if shift
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
        update_cursor true
      end

      def cursor_home shift
        if shift
          @selection_max = @selection_min if @cursor_position == @selection_max
          @selection_min = @cursor_position = 0
          update_cursor true
        else
          reset_cursor 0, true
        end
      end

      def cursor_end shift
        if shift
          @selection_min = @selection_max if @cursor_position == @selection_min
          @selection_max = @cursor_position = @text.string.length
          update_cursor true
        else
          reset_cursor @text.string.length, true
        end
      end


      aliasing def s! str = "", reset_cursor = true, &block
        str = block.call @text.string, str if block
        @text.string != str && begin
          @text.string = str
          self.reset_cursor if reset_cursor
          w! @text.w.ceil if autosized?
          true
        end
      end, :s=, :string!, :string=

      aliasing def s
        @text.string
      end, :string

      def_delegators :@text,
        :color, :color!, :color=

      def_flag :autosized!, true, true
    end
  end
end