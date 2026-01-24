require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextVerse < NavigableTextPad

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
          report TextEdition::EditEvent.new @selection_min, @selection_max, "", :delete
        elsif @cursor_position < length
          report TextEdition::EditEvent.new @cursor_position, @cursor_position + 1, "", :delete
        elsif length > 0
          backspace
        end
      end

      def content! content = @content, cursor_position = 0, &b
        super("#{content}\n".each_line(chomp: true).to_a.join, cursor_position, &b)
      end

      def edit new_content, new_cursor_position
        v = @verses.first
        w0 = v.w
        content! new_content, new_cursor_position
        case @verse_layout
        when :yss, :ysc, :yse
          nil
        when :yes, :yec, :yee
          v = @verses.first
          @scene.x = sx >= 0 && v.w > sw ? @scene.x + v.w - w0 : 0
        when :ycs, :ycc, :yce
          @scene.x = 0
        else raise_is @verse_layout
        end
      end
    end
  end
end