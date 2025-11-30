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

      feature def fill! *fill
        fill = Util.uncover fill
        return if @fill == fill
        @fill = fill
        repaint
        true
      end

      event_resolver :on_pick!, PickEvent

      feature_delegate :@text,
        :content

      def has_subitem?
        false
      end

      def down? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        pin_top? :primary or (
          keyboard_in and (
            keyboard.down? :space or
            keyboard.down? :enter
          )
        )
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @text = new TextPad, "", mousy: false
      end

      def sketch
        super

        keyboardy!
        layout! :xbc
        fill! :gray
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
        color = Kredki.color @fill
        area.fill = pin_in? ? color.darken : keyboard_in? ? color.lighten : color
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
