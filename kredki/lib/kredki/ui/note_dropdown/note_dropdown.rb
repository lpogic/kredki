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

      def item! *a, **na, &b
        dropdown!.item! *a, w: 100r, **na, &b
      end

      #internal api

      def initialize
        super

        @picked = nil
        @arrow = new ButtonPad, w: 20, h: 100r, x: :e do
          theme! :gray
          stroke_size! 0
          keyboardy! false
          text.detach!
          new Pad, mousy: false, keyboardy: false, color: 0, wh: 100r do
            stroke! color: :text, size: 3, cap: :round, join: :miter
            area! do |xs, ys|
              xy! xs * -0.5, ys * -0.3
              line! 0, ys * 0.2
              line! xs * 0.5, ys * -0.3
            end
          end
        end
      end

      def sketch p0
        super

        m! 1
        @verse.w = -20
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

        @dropdown.on! Item::PickEvent do |e|
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