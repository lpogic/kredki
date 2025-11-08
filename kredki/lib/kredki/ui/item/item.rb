require_relative '../text_pad'

module Kredki
  module UI
    class Item < ShapePad
      extend HasEventResolvers

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      class PickEvent < Kredki::UI::Event
        model :value, :origin

        def ~()
          @value
        end
      end

      param def color! *color
        color = Util.uncover color
        return if @color == color
        @color = color
        repaint
        true
      end

      event_resolver :on_pick!, PickEvent

      param_delegate :@text,
        :content

      def has_subitem?
        false
      end

      def down? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        pin_top? :primary or (
          keyboard_in and (
            key_down? :space or
            key_down? :enter
          )
        )
      end

      #internal api

      def initialize
        super
        
        @text = new TextPad, "", mousy: false
      end

      def sketch
        super

        keyboardy!
        layout! :xbc
        color! :gray
        h! 24
        w! :fit
      end

      def sketch_presence
        super
        
        Event.each(
          on_focus_enter!,
          on_focus_leave!,
          on_mouse_down!,
          on_mouse_up!,
          on_mouse_enter!,
          on_mouse_leave!,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @color
        area.fill_color = pin_in? ? color.darken : keyboard_in? ? color.lighten : color
      end

      def sketch_behavior
        super

        on_mouse_click! :primary do |e|
          report PickEvent.new(content, e)
        end

        on_key! :space, :enter do |e|
          report PickEvent.new(content, e)
          e.resolve
        end
      end

      def mouse_enter e
        # parent&.mouse_enter self if action.event.is_a? Kredki::UI::PositionEvent
        parent&.mouse_enter self
      end

      def min_w
        @text.fit_w
      end
    end
  end
end
