require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextVerse < NavigableTextPad

      # :section: LEVEL 2

      def paste pasted
        new_content = content_after_edit pasted, @selection_start, @selection_end
        report TextEdition::EditEvent.new @selection_start, @selection_end, new_content, pasted, :paste
      end

      def backspace
        if any_selected
          new_content = content_after_edit "", @selection_start, @selection_end
          report TextEdition::EditEvent.new @selection_start, @selection_end, new_content, "", :backspace
        elsif @cursor_position > 0
          new_content = content_after_edit "", @cursor_position - 1, @cursor_position
          report TextEdition::EditEvent.new @cursor_position - 1, @cursor_position, new_content, "", :backspace
        end
      end

      def delete
        length = text.length
        if any_selected
          new_content = content_after_edit "", @selection_start, @selection_end
          report TextEdition::EditEvent.new @selection_start, @selection_end, new_content, "", :delete
        elsif @cursor_position < length
          new_content = content_after_edit "", @cursor_position, @cursor_position + 1
          report TextEdition::EditEvent.new @cursor_position, @cursor_position + 1, new_content, "", :delete
        elsif length > 0
          backspace
        end
      end

      def set_subject subject = @subject, cursor_position = 0, &b
        super("#{subject}\n".each_line(chomp: true).to_a.join, cursor_position, &b)
      end

      def edit new_content, new_cursor_position
        v = @verses.first
        initial_size_x = v.size_x
        set_subject new_content, new_cursor_position
        case @verse_layout
        when :yss, :ysc, :yse
          nil
        when :yes, :yec, :yee
          v = @verses.first
          @scene.x = area_x >= 0 && v.size_x > area_size_x ? @scene.x + v.size_x - initial_size_x : 0
        when :ycs, :ycc, :yce
          @scene.x = 0
        else raise_is @verse_layout
        end
      end

      def drop_move x, y
        cursor_position = cursor_position_for_coordinates x, y
        if @cursor_position != cursor_position && @selection_start == @selection_end
          @selection_start = @selection_end = @cursor_position = cursor_position
          layer&.break_layout
        end
      end

      def content_after_edit inset, from, to
        string = text.to_s
        if string == ""
          inset
        elsif to < string.length
          string[...from] + inset + string[to..]
        else
          string[...from] + inset
        end
      end
    end
  end
end