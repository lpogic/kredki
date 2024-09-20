module Kredki
  module UI
    class Input < Pad

      def sketch p0
        super

        text = nil
        selection = nil
        cursor = nil

        @cursor_position = @selection_min = @selection_max = 0

        pad = pad! color: :transparent, keyboardy: false, mousy: false, x: 5, y: 5 do |p2|

          selection = rectangle! x: 0, y: 0, w: 0, color: :blue do
            clip! p2.body
          end
    
          text = text! x: 0, y: 0, color: :white, font: :arial, h: 24 do
            clip! p2.body
            string! "Tee"
          end
    
          cursor = rectangle! x: 0, y: 0, color: :black, w: 2
    
          p2.h = text.h
    
          on_resize! do
            selection.h = h
            cursor.h = h
            p0.h = text.h + 10
          end.call
        end

        pad.w = w - 10
    
        @update_cursor = proc do |move|
          x = text.substring_width @cursor_position
          case move
          when :right
            if text.x + x > pad.w
              cursor.x = pad.w - 1
              text.x = pad.w - x
            else
              cursor.x = text.x + x - 1
            end
          when :left
            if text.x + x < 0
              cursor.x = -1
              text.x = -x
            else
              cursor.x = text.x + x - 1
            end
          else
            if x < pad.w
              cursor.x = x - 1
              text.x = 0
            elsif text.x + x < pad.w && text.x + x > 0
              cursor.x = text.x + x - 1
            else
              cursor.x = pad.w / 2 - 1
              text.x = pad.w / 2 - x
            end
          end
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
    
    
        on_text! do |e|
          str = text.string
          if str != ""
            text.string = str[...@selection_min] + e[] + str[@selection_max..]
          else
            text.string = e[]
          end
          @selection_min = @selection_max = @cursor_position = @selection_min + e[].length
          @update_cursor.call :right
          p0.event PadEditEvent.new
        end
    
        on_key! :left do |e|
          if e.shift?
            if @cursor_position > 0 && @cursor_position == @selection_min
              @selection_min = @cursor_position -= 1
            elsif @cursor_position == @selection_max
              @selection_max = @cursor_position -= 1
            end
          else
            @cursor_position -= 1 if @cursor_position > 0
            @selection_min = @selection_max = @cursor_position
          end
          @update_cursor.call :left
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
            @cursor_position += 1 if @cursor_position < str.length
            @selection_min = @selection_max = @cursor_position
          end
          @update_cursor.call :right
        end
    
        on_key! :backspace do
          str = text.string
          if @selection_min != @selection_max
            text.string = str[...@selection_min] + str[@selection_max..]
            @selection_max = @cursor_position = @selection_min
            p0.event PadEditEvent.new
          elsif @cursor_position > 0
            text.string = str[...(@cursor_position - 1)] + str[@cursor_position..]
            @selection_min = @selection_max = @cursor_position -= 1
            p0.event PadEditEvent.new
          end
          @update_cursor.call
        end
    
        on_key! :delete do
          str = text.string
          if @selection_min != @selection_max
            text.string = str[...@selection_min] + str[@selection_max..]
            @selection_max = @cursor_position = @selection_min
            p0.event PadEditEvent.new
          elsif @cursor_position < str.length
            text.string = str[...@cursor_position] + str[(@cursor_position + 1)..]
            p0.event PadEditEvent.new
          end
          @update_cursor.call
        end
    
        on_state! do
          color = Kredki.color :gray
          body.color = mouse_in? ? color.light(20) : color
        end.call

        on_focus_gain! do
          cursor.show!
        end

        on_focus_lose! do
          cursor.hide!
        end.call

        @text = text
      end

      aliasing def string! str
        @text.string = str
        @selection_min = @selection_max = @cursor_position = 0
        @update_cursor.call
      end, :string=

      def string
        @text.string
      end

      def on_edit! &block
        on_event! PadEditEvent, &block
      end

      def autosized?
        true
      end
    end
  end
end