require_relative '../note'
require_relative 'option_layer'

module Kredki
  module UI
    # Control to pick option from list.
    class Option < Pad

      # Get picked option value.
      def picked
        @picked
      end

      # Add new item.
      def item! ...
        dropdown!.item!(w: 1r).alter(...)
      end

      # Create/Update dropdown.
      def dropdown! ...
        @dropdown ||= new OptionLayer
        @dropdown.alter(...)
      end

      # Get dropdown.
      def dropdown
        @dropdown
      end

      # Create and attach pick event resolver.
      def on_pick! ...
        on!(Item::PickEvent, ...)
      end

      # See #on_pick!.
      def on_pick= param
        on_pick! do: param
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
          new RectanglePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
            outline! fill: :text, w: 3, cap: :round
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

      def behavior
        super

        Event.each on_key!(:enter) do
          @dropdown.load self unless @dropdown.loaded?
        end

        # Event.each on_move!, on_resize! do |e|
        #   @dropdown.break_layout
        # end

        on_mouse_click! :primary do
          @dropdown.load self unless @dropdown.loaded?
        end

        @arrow.on_mouse_click! :primary do |e|
          if @dropdown.loaded?
            @dropdown.unload
          else
            @dropdown.load self
          end
          e.resolve
        end

        @arrow.on_mouse_move! do
          if it.drag
            it.resolve
          end
        end

        on_pick! do |e|
          @dropdown.unload
          content = e.target.content
          @note.content! content
          @note.verse.set_cursor content.to_s.length
        end

        @dropdown.on_key! :escape do
          @dropdown.unload
          it.resolve
        end

        on_focus_leave! do
          @dropdown.unload
        end
      end
    end
  end
end