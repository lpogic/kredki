require_relative '../note'
require_relative 'note_dropdown_layer'

module Kredki
  module UI
    class NoteDropdown < Note

      attr :picked

      def dropdown! ...
        @dropdown ||= new NoteDropdownLayer do
          pad_detach
        end

        @dropdown.alter(...)
      end

      def option! *a, **na, &b
        dropdown!.option! *a, w: 100r, **na, &b
      end

      #internal api

      def initialize
        super

        @picked = nil
        @arrow = new ButtonPad, w: 20, h: 100r, x: 100r do
          theme! :gray
          stroke_size! 0
          keyboardy! false
          text.detach!
          new Pad, mousy: false, keyboardy: false, color: 0, wh: 100r do
            stroke! color: :text, size: 3, cap: :round, join: :miter
            area! do |w, h|
              move_to! w / 5, h / 3
              line_to! w / 2, h * 2 / 3
              line_to! w * 4 / 5, h / 3
            end
          end
        end
      end

      def sketch p0
        super

        @text.w = -20
        dropdown!

        Event.group on_key!(:enter) do
          @dropdown.load! self unless @dropdown.loaded?
        end

        Event.group on_move!, on_resize! do |e|
          @dropdown.break_layout
        end

        @arrow.on_mouse_click! :primary do
          @dropdown.load! self unless @dropdown.loaded?
        end

        @arrow.on_mouse_move! do
          if it.drag
            it.resolve
          end
        end

        @dropdown.on! Option::PickEvent do |e|
          @dropdown.unload!
          content! ~e, :end
        end

        @dropdown.on_key! :escape do
          @dropdown.unload!
          it.resolve
        end

        # @dropdown.on_mouse_button! do
        #   @dropdown.unload!
        # end

        on_focus_leave! do
          @dropdown.unload!
        end
      end
    end
  end
end