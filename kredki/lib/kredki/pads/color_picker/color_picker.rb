require_relative '../note'
require_relative 'color_picker_layer'
require_relative 'color_picker_pad'

module Kredki
  module Pads
    # Control to select option from list.
    class ColorPicker < Pad

      feature :color

      def set_color color
        return if @color == color
        @color = color
        upper(ColorPickerPad).set_color Kredki.color color
      end

      def color
        @color
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

      # :section: LEVEL 2

      def initialize
        super

        @note = put Note, size: 1r
        @button = default_picker_button
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
            # self[:item!, keyboard_in: true]&.report_selected e
          else
            @dropdown.load self
          end
        end

        on_mouse_click :primary do
          @dropdown.load self unless @dropdown.loaded
        end

        @button.on_mouse_click :primary do |e|
          if @dropdown.loaded
            @dropdown.unload
          else
            @dropdown.load self
          end
          e.close
        end

        @button.on_mouse_move do |it|
          if it.drag?
            it.close
          end
        end

        @note.on_edit do
          begin
            color = Color.parse @note.text
            upper(ColorPickerPad).set_color color, update_note: false
          rescue
          end
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
        put ColorPickerLayer
      end

      def default_picker_button
        @note.put Button, size: [20, 1r] do
          set stroke_width: 0
          set keyboardy: false
          set layout: :zcc
          # put RectanglePad, size: 1r do
          #   set_area do |sx, sy|
          #     rx = (sx + 16) / 16
          #     ry = (sy + 8) / 8
          #     rx.times do |i|
          #       ry.times do |j|
          #         jump i * 16 + (j % 2 == 0 ? 4 : 12), j * 8 + 4
          #         rectangle 8, 8
          #       end
          #     end
          #   end
          # end
          put RectanglePad, :color, mousy: false, keyboardy: false, size: 1r, margin: 3, stroke: [2, :white]
        end
      end
    end
  end
end