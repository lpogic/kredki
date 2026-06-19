module Kredki
  module Pads
    class EditableTextVerses < EditableTextPad

      # :section: LEVEL 2

      def edit new_content, new_cursor_position
        set_subject new_content, new_cursor_position
      end
      
    end
  end
end