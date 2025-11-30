require_relative '../note'
require_relative 'option_layer'

module Kredki
  module UI
    class Option < Pad

      attr :picked

      def dropdown! ...
        @dropdown ||= new OptionLayer do
          pad_detach
        end

        @dropdown.alter(...)
      end

      def item! ...
        dropdown!.item!(w: 1r).alter(...)
      end

      # :section: LEVEL 2

      def initialize
        super

        @picked = nil
        @note = new Note
        @arrow = @note.new Button, w: 20, h: 1r do
          outline_w! 0
          keyboardy! false
          text.detach!
          new ShapePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
            out! fill: :text, w: 3, cap: :round, join: :miter
            area! do |w, h|
              xy! w * 0.2, h * 0.35
              line! w * 0.5, h * 0.65
              line! w * 0.8, h * 0.35
            end
          end
        end
      end

      def sketch
        super

        h! 24
        @note.wh! 1r
        dropdown!
      end

      def sketch_behavior
        super

        Event.each on_key!(:enter) do
          @dropdown.load! self unless @dropdown.loaded?
        end

        Event.each on_move!, on_resize! do |e|
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
          @note.content! e.param, :end
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