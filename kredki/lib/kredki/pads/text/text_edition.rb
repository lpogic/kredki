require_relative 'text_navigation'

module Kredki
  module Pads
    # Common event reactions for text edition.
    module TextEdition
      include TextNavigation
      extend Reactions

      class EditEvent < Event
        def param
          new_content
        end

        # :section: LEVEL 2

        def initialize selection_start, selection_end, old_part, new_part, new_content, action
          super()
          @selection_start = selection_start
          @selection_end = selection_end
          @old_part = old_part
          @new_part = new_part
          @new_content = new_content
          @action = action
        end

        attr_accessor :selection_start
        attr_accessor :selection_end
        attr_accessor :old_part
        attr_accessor :new_part
        attr_accessor :new_content
        attr_accessor :action        
      end

      reaction EditEvent, :on_edit

      def text_edition text, multiline
        text_navigation text

        on_key_press do |e|
          e.close false if (32..122).include? e.code
        end

        on_key_press :backspace do |e|
          text.backspace
          e.close
        end

        on_key_press :delete do |e|
          text.delete
          e.close
        end

        on_text_input do |e|
          text.text_input e.param
          e.close
        end

        on_key_press :v do |e|
          if e.ctrl?
            text.paste Kredki.clipboard.content
            e.close
          end
        end

        on_key_press :x do |e|
          if e.ctrl? && text.any_selected
            Kredki.clipboard.content = text.selected_content if text.any_selected
            text.paste ""
            e.close
          end
        end

        on_key_press :z do |e|
          if e.ctrl? && @history_model
            if e.shift?
              @history_model&.step_forward text
            else
              @history_model&.step_backward text
            end
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
          text.edit e.new_content, e.selection_start + e.new_part.length
          @history_model.push_event e
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