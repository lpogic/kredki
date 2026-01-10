require_relative 'text_edition'

module Kredki
  module UI
    class EditableTextVerses < NavigableText

      # :section: LEVEL 2

      def paste pasted
        report TextEdition::EditEvent.new @selection_min, @selection_max, pasted, :paste
      end

      def backspace
        if selection?
          report TextEdition::EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position > 0
          report TextEdition::EditEvent.new @cursor_position - 1, @cursor_position, "", :backspace
        end
      end

      def delete
        length = content.length
        if selection?
          report TextEdition::EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position < length
          report TextEdition::EditEvent.new @cursor_position, @cursor_position + 1, "", :backspace
        end
      end

      def edit new_content, new_cursor_position
        content! new_content, new_cursor_position
      end
    end
  end
end