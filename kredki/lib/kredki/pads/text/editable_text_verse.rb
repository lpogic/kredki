require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextVerse < EditableTextPad

      # :section: LEVEL 2

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

    end
  end
end