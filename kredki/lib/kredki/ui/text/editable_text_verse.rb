require_relative 'text_edition'

module Kredki
  module UI
    class EditableTextVerse < NavigableText
      extend HasEventResolvers

      event_resolver :on_edit, EditEvent

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
          report EditEvent.new @selection_min, @selection_max, "", :delete
        elsif @cursor_position < length
          report EditEvent.new @cursor_position, @cursor_position + 1, "", :delete
        elsif length > 0
          backspace
        end
      end

      def content! content = @content, reset_cursor = false, &b
        super("#{content}\n".each_line(chomp: true).to_a.join, reset_cursor, &b)
      end

      def edit action, new_content, selection_min, selection_max
        v = @verses.first
        w0 = v.w
        c0 = v.content
        s = content.to_s
        s = if s == ""
          new_content
        elsif selection_max < s.length
          s[...selection_min] + new_content + s[selection_max..]
        else
          s[...selection_min] + new_content
        end
        content! s, false
        case @verse_layout
        when :ybb, :ybc, :ybe
          nil
        when :yeb, :yec, :yee
          v = @verses.first
          @scene.x = sx >= 0 && v.w > sw ? @scene.x + v.w - w0 : 0
        when :ycb, :ycc, :yce
          @scene.x = 0
        else raise_is @verse_layout
        end
        reset_cursor selection_min + new_content.length
      end
    end
  end
end