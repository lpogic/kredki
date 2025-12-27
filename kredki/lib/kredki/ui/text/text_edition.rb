require_relative 'text_navigation'

module Kredki
  module UI
    # Common event resolvers for text edition.
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
          @action  = action
        end

        attr_accessor :selection_min
        attr_accessor :selection_max
        attr_accessor :string
        attr_accessor :action
        
      end
      
      def on_edit! &block
        on! EditEvent, &block
      end

      def text_edition text, multiline
        text_navigation text

        on_key_down! :backspace do |e|
          text.backspace
          e.resolve
        end

        on_key_down! :delete do |e|
          text.delete
          e.resolve
        end

        on_text! do |e|
          text.paste e.param
          e.resolve
        end

        on_key_down! :v do |e|
          if e.ctrl?
            text.paste Kredki.clipboard.content
            e.resolve
          end
        end

        on_key_down! :x do |e|
          if e.ctrl? && (text.selection? || e.shift?)
            s = e.shift? ? clipboard.content : ""
            clipboard.content = text.selected_content if text.selection?
            text.paste s
            e.resolve
          end
        end

        on_edit! do |e|
          content = content_after_edit e
          cursor_position = e.string.length + e.selection_min
          text.edit e.action, content, cursor_position
        end

        if multiline
          on_key_down! :enter do |e|
            text.paste "\n"
            e.resolve
          end
        end
      end

    end
  end
end