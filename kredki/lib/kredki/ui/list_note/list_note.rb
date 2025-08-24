require_relative '../note'
require_relative 'list_note_layer'

module Kredki
  module UI
    class ListNote < Pad

      attr :picked

      def dropdown! ...
        @dropdown ||= new ListNoteLayer do
          pad_detach
        end

        @dropdown.alter(...)
      end

      def item! ...
        dropdown!.item!(w: 1r).alter(...)
      end

      #internal api

      def initialize
        super

        @picked = nil
        @note = new Note
        @arrow = @note.new ButtonPad, w: 20, h: 1r do
          stroke_size! 0
          keyboardy! false
          text.detach!
          new ShapePad, mousy: false, keyboardy: false, color: 0, wh: 1r do
            stroke! color: :text, size: 3, cap: :round, join: :miter
            area! do |w, h|
              xy! w * 0.2, h * 0.35
              line! w * 0.5, h * 0.65
              line! w * 0.8, h * 0.35
            end
          end
        end
      end

      def sketch p0
        super

        h! 24
        @note.wh! 1r
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
          @note.content! ~e, :end
        end

        @dropdown.on_key! :escape do
          @dropdown.unload!
          it.resolve
        end

        on_focus_leave! do
          @dropdown.unload!
        end
      end
    end
  end
end