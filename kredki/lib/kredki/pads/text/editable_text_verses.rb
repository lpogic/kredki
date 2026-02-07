require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextVerses < NavigableTextPad

      # :section: LEVEL 2

      def paste pasted
        new_content = content_after_edit pasted, @selection_min, @selection_max
        report TextEdition::EditEvent.new @selection_min, @selection_max, new_content, pasted, :paste
      end

      def backspace
        if selection?
          new_content = content_after_edit "", @selection_min, @selection_max
          report TextEdition::EditEvent.new @selection_min, @selection_max, new_content, "", :backspace
        elsif @cursor_position > 0
          new_content = content_after_edit "", @cursor_position - 1, @cursor_position
          report TextEdition::EditEvent.new @cursor_position - 1, @cursor_position, new_content, "", :backspace
        end
      end

      def delete
        length = content.length
        if selection?
          new_content = content_after_edit "", @selection_min, @selection_max
          report TextEdition::EditEvent.new @selection_min, @selection_max, new_content, "", :delete
        elsif @cursor_position < length
          new_content = content_after_edit "", @cursor_position, @cursor_position + 1
          report TextEdition::EditEvent.new @cursor_position, @cursor_position + 1, new_content, "", :delete
        end
      end

      def edit new_content, new_cursor_position
        content! new_content, new_cursor_position
      end

      def drop_move x, y
        cursor_position = cursor_position_for_coordinates x, y
        if @cursor_position != cursor_position && @selection_min == @selection_max
          @selection_min = @selection_max = @cursor_position = cursor_position
          layer&.break_layout
        end
      end

      def content_after_edit string, from, to
        s = content.to_s
        s = if s == ""
          string
        elsif to < s.length
          s[...from] + string + s[to..]
        else
          s[...from] + string
        end
      end
    end
  end
end