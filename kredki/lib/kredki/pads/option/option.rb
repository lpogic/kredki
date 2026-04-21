require_relative '../note'
require_relative 'option_layer'

module Kredki
  module Pads
    # Control to select option from list.
    class Option < Pad

      # Add new item.
      def item! ...
        dropdown!.item!(size_x: 1r).set(...)
      end

      # Create/Update dropdown.
      def dropdown! ...
        @dropdown ||= default_dropdown_layer
        @dropdown.set(...)
      end

      # Get dropdown.
      def dropdown
        @dropdown
      end

      # Create and attach select event reaction.
      def on_select ...
        on(Item::SelectEvent, ...)
      end

      # See #on_select.
      def on_select= param
        on_select do: param
      end

      # :section: LEVEL 2

      def initialize
        super

        @note = put Note, size: 1r
        @arrow = default_arrow_button
      end

      def sketch
        super
        
        set_size_y 24
        dropdown!
      end

      def behavior
        super

        on_key :enter do |e|
          if @dropdown.loaded
            item?(keyboard_in: true)&.report_selected e
          else
            @dropdown.load self
          end
        end

        on_mouse_click :primary do
          @dropdown.load self unless @dropdown.loaded
        end

        @arrow.on_mouse_click :primary do |e|
          if @dropdown.loaded
            @dropdown.unload
          else
            @dropdown.load self
          end
          e.close
        end

        @arrow.on_mouse_move do |it|
          if it.drag?
            it.close
          end
        end

        on_select do |e|
          @dropdown.unload
          subject = e.target.find_upper(TextPad).subject
          set_subject subject
          @note.set_text subject
          @note.verse.update_cursor subject.to_s.length
        end

        @dropdown.on_key :escape do |it|
          @dropdown.unload
          it.close
        end

        on_focus_leave do
          @dropdown.unload
        end
      end

      def default_dropdown_layer
        put OptionLayer
      end

      def default_arrow_button
        @note.put Button, size: [20, 1r] do
          set stroke_width: 0
          set keyboardy: false
          put RectanglePad, mousy: false, keyboardy: false, fill: 0, size: 1r do
            set_stroke fill: :text, width: 2, cap: :round
            set_area do |sx, sy|
              jump sx * 0.2, sy * 0.35
              line sx * 0.5, sy * 0.65
              line sx * 0.8, sy * 0.35
            end
          end
        end
      end
    end
  end
end