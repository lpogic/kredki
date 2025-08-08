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

      def edit action, new_content, selection_min, selection_max
        s = content.to_s
        s = if s == ""
          new_content
        elsif selection_max < s.length
          s[...selection_min] + new_content + s[selection_max..]
        else
          s[...selection_min] + new_content
        end
        content! s, false
        reset_cursor selection_min + new_content.length
      end
    end
  end
end