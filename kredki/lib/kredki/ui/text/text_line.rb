require_relative 'text'

module Kredki
  module UI
    class TextLine < Text

      def initialize
        super
        
        @cursor_position = @selection_min = @selection_max = 0
        @cursor = @scene.rectangle! x: 1, y: 0, color: :black, w: 2, h: 30
        @selection = @scene.rectangle! x: 0, y: 0, w: 0, h: 30, color: :blue, clip!: @body
        @text = @scene.text! x: @cursor.w / 2, y: 0, color: :white, font: :arial, h: 30, clip!: @body
      end

      def sketch p0
        super

        p0.wh = @text.wh

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

      aliasing def s! str = "", reset_cursor = true, &block
        string = self.string
        str = block.call string, str if block
        string != str && begin
          @text.s! str
          w = @text.w.ceil
          update_text
          wh! w + @cursor.w, @text.h
          self.reset_cursor if reset_cursor
          true
        end
      end, :s=, :string!, :string=

      def_delegators :@text,
        :s, :string, 
        :color!, :color=, :color

      aliasing def fh! height
        height != @text.h && begin
          @cursor.h = @text.h = @selection.h = height
          w = @text.w.ceil
          update_text
          wh! w + @cursor.w, @text.h
          true
        end
      end, :fh=, :font_height!, :font_height=

      aliasing def fh
        @text.h
      end, :font_height

      def string_length
        @text.string.length
      end
    end
  end
end