require_relative 'text'

module Kredki
  module UI
    class TextLine < Text

      param def string! string = "", reset_cursor = true
        @text.string! string and update_line_size reset_cursor
      end, get: def string
        @text.string
      end

      param def color! *color
        @text.color! *color
      end, get: def color
        @text.color
      end

      param def font! font
        @text.font! font
      end, get: def font
        @text.font
      end

      param def font_height! height
        height != @text.h && begin
          @cursor.h = @text.h = @selection.h = height
          w = @text.w.ceil
          update_text
          wh! w + @cursor.w, @text.h
          true
        end
      end, get: def font_height
        @text.h
      end

      # internal api

      def initialize
        super
        
        @cursor_position = @selection_min = @selection_max = 0
        @selection = @clip_scene.rectangle! x: 0, y: 0, h: 24, color: :blue, clip!: @clip_area
        @cursor = @clip_scene.rectangle! x: 1, y: 0, color: :white, w: 2, h: 24
        @text = @clip_scene.text! x: @cursor.w / 2, color: :white, font: :arial, h: 24, clip!: @clip_area
      end

      def sketch p0
        super

        update_line_size false

        on_focus_lose! do |e|
          @cursor.hide!
          @selection.hide!
          e.resolve
        end.resolve FocusLoseEvent.new

        on_focus_gain! do |e|
          @selection.show!
          @cursor.show!
          e.resolve
        end
      end

      def cursor_position x, y
        @text.nearest_character_index x - @text.x
      end

      def update_line_size cursor_position
        update_text
        wh! @text.w + @cursor.w, @text.h
        case cursor_position
        when true, :begin then reset_cursor
        when :end then reset_cursor string_length
        when Integer then reset_cursor cursor_position
        end
        true
      end

      def pw
        w
        # @me + @mw + @text.w + @cursor.w
      end

      def ph
        h
        # @mn + @ms + @text.h
      end

      def update_text
        @text.x! @cursor.w / 2
        update_cursor
      end

      def update_cursor
        x = @text.substring_width @cursor_position
        if @cursor.x! x
          report ROIEvent.new(*@cursor.wh, *translate(*@cursor.xy))
        end

        if @selection_min == @selection_max
          @selection.w = 0
        else
          x1 = @text.substring_width @selection_min
          x2 = @text.substring_width @selection_max
          @selection.w = x2 - x1
          @selection.x = @text.x + x1
        end
      end

      def cursor_home shift, ctrl
        cursor_position = 0

        if shift
          @selection_max = @selection_min if @cursor_position == @selection_max
          @cursor_position = @selection_min = cursor_position
          update_cursor
        else
          reset_cursor cursor_position
        end
      end

      def cursor_end shift, ctrl
        cursor_position = string_length

        if shift
          @selection_min = @selection_max if @cursor_position == @selection_min
          @cursor_position = @selection_max = cursor_position
          update_cursor
        else
          reset_cursor cursor_position
        end
      end

      def string_length
        @text.string.length
      end
    end
  end
end