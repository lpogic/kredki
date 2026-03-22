require_relative '../note'
require_relative 'option_layer'

module Kredki
  module Pads
    # Control to pick option from list.
    class Option < Pad

      # Get picked option value.
      def picked
        @picked
      end

      # Add new item.
      def item! ...
        dropdown!.item!(size_x: 1r).set(...)
      end

      # Create/Update dropdown.
      def dropdown! ...
        @dropdown ||= put OptionLayer
        @dropdown.set(...)
      end

      # Get dropdown.
      def dropdown
        @dropdown
      end

      # Create and attach pick event reaction.
      def on_pick ...
        on(Item::PickEvent, ...)
      end

      # See #on_pick.
      def on_pick= param
        on_pick do: param
      end

      # :section: LEVEL 2

      def initialize
        super

        @picked = nil
      end

      def sketch
        super

        @note = put Note
        @arrow = @note.put Button, size: [20, 1r] do
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

        set_size_y 24
        @note.set_size 1r
        dropdown!
      end

      def behavior
        super

        on_key :enter do |e|
          if @dropdown.loaded?
            item?(keyboard_in: true)&.report Item::PickEvent.new e
          else
            @dropdown.load self
          end
        end

        # Event.each on_move, on_resize do |e|
        #   @dropdown.break_layout
        # end

        on_mouse_click :primary do
          @dropdown.load self unless @dropdown.loaded?
        end

        @arrow.on_mouse_click :primary do |e|
          if @dropdown.loaded?
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

        on_pick do |e|
          @dropdown.unload
          subject = e.target.find_upper(TextPad).subject
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
    end
  end
end