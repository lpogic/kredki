require_relative 'text_edition'

module Kredki
  module Pads
    class EditableTextPad < NavigableTextPad

      # :section: LEVEL 2

      def text_input inset
        report_edit_event @selection_start, @selection_end, inset, :text_input
      end

      def paste pasted
        report_edit_event @selection_start, @selection_end, pasted, :paste
      end

      def backspace
        if any_selected
          report_edit_event @selection_start, @selection_end, "", :backspace_selected
        elsif @cursor_position > 0
          report_edit_event @cursor_position - 1, @cursor_position, "", :backspace
        end
      end

      def delete
        if any_selected
          report_edit_event @selection_start, @selection_end, "", :delete_selected
        elsif @cursor_position < text.length
          report_edit_event @cursor_position, @cursor_position + 1, "", :delete
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
          ["", inset]
        elsif to < string.length
          [string[from...to], string[...from] + inset + string[to..]]
        else
          [string[from..], string[...from] + inset]
        end
      end

      def report_edit_event selection_start, selection_end, new_part, action
        old_part, new_content = content_after_edit new_part, selection_start, selection_end
        report TextEdition::EditEvent.new selection_start, selection_end, old_part, new_part, new_content, action
      end
    end
  end
end