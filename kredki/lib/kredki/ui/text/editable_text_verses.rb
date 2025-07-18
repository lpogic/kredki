require_relative 'text_edition'

module Kredki
  module UI
    class EditableTextVerses < NavigableText

      def paste pasted
        report EditEvent.new @selection_min, @selection_max, pasted, :paste
      end

      def backspace
        if selection?
          report EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position > 0
          report EditEvent.new @cursor_position - 1, @cursor_position, "", :backspace
        end
      end

      def delete
        length = content.length
        if selection?
          report EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position < length
          report EditEvent.new @cursor_position, @cursor_position + 1, "", :backspace
        elsif length > 0
          backspace
        end
      end

      def edit string, selection_min, selection_max
        s = content.to_s
        s = if s == ""
          string
        elsif selection_max < s.length
          s[...selection_min] + string + s[selection_max..]
        else
          s[...selection_min] + string
        end
        content! s, false
        @scene.x = 0
        reset_cursor selection_min + string.length
      end
    end
  end
end