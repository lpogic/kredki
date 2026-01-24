require_relative 'text_navigation'

module Kredki
  module Pads
    # Common event reactions for text edition.
    module TextEdition
      include TextNavigation

      class EditEvent < Event
        def param
          string
        end

        # :section: LEVEL 2

        def initialize selection_min, selection_max, string, action
          super()
          @selection_min = selection_min
          @selection_max = selection_max
          @string = string
          @action = action
        end

        attr_accessor :selection_min
        attr_accessor :selection_max
        attr_accessor :string        
        attr_accessor :action        
      end
      
      def on_edit ...
        on(EditEvent, ...)
      end

      def text_edition text, multiline
        text_navigation text

        on_key_press :backspace do |e|
          text.backspace
          e.close
        end

        on_key_press :delete do |e|
          text.delete
          e.close
        end

        on_text_input do |e|
          text.paste e.param
          e.close
        end

        on_key_press :v do |e|
          if e.ctrl?
            text.paste Kredki.clipboard.content
            e.close
          end
        end

        on_key_press :x do |e|
          if e.ctrl? && (text.selection? || e.shift?)
            s = e.shift? ? clipboard.content : ""
            clipboard.content = text.selected_content if text.selection?
            text.paste s
            e.close
          end
        end

        on_edit early: true do |e|
          content = content_after_edit e
          cursor_position = e.string.length + e.selection_min
          text.edit content, cursor_position
        end

        if multiline
          on_key_press :enter do |e|
            text.paste "\n"
            e.close
          end
        end
      end

    end
  end
end