require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextVerse < NavigableTextPad

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
        length = text.length
        if selection?
          new_content = content_after_edit "", @selection_min, @selection_max
          report TextEdition::EditEvent.new @selection_min, @selection_max, new_content, "", :delete
        elsif @cursor_position < length
          new_content = content_after_edit "", @cursor_position, @cursor_position + 1
          report TextEdition::EditEvent.new @cursor_position, @cursor_position + 1, new_content, "", :delete
        elsif length > 0
          backspace
        end
      end

      def subject! subject = @subject, cursor_position = 0, &b
        super("#{subject}\n".each_line(chomp: true).to_a.join, cursor_position, &b)
      end

      def edit new_content, new_cursor_position
        v = @verses.first
        initial_size_x = v.size_x
        subject! new_content, new_cursor_position
        case @verse_layout
        when :yss, :ysc, :yse
          nil
        when :yes, :yec, :yee
          v = @verses.first
          @scene.x = sx >= 0 && v.size_x > area_size_x ? @scene.x + v.size_x - initial_size_x : 0
        when :ycs, :ycc, :yce
          @scene.x = 0
        else raise_is @verse_layout
        end
      end

      def drop_move x, y
        cursor_position = cursor_position_for_coordinates x, y
        if @cursor_position != cursor_position && @selection_min == @selection_max
          @selection_min = @selection_max = @cursor_position = cursor_position
          layer&.break_layout
        end
      end

      def content_after_edit string, from, to
        s = text.to_s
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