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

        def initialize selection_start, selection_end, string, inset, action
          super()
          @selection_start = selection_start
          @selection_end = selection_end
          @string = string
          @inset = inset
          @action = action
        end

        attr_accessor :selection_start
        attr_accessor :selection_end
        attr_accessor :string
        attr_accessor :inset
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
          if e.ctrl? && (text.any_selected || e.shift?)
            s = e.shift? ? clipboard.content : ""
            Kredki.clipboard.content = text.selected_content if text.any_selected
            text.paste s
            e.close
          end
        end

        on_mouse_move do |e|
          if e.drop?
            text.drop_move *text.layer.translate(*e.xy, text)
            e.close
          end
        end

        on_drop do |e|
          text.paste e.param
          e.close
        end

        on_edit early: true do |e|
          cursor_position = e.inset.length + e.selection_start
          text.edit e.string, cursor_position
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