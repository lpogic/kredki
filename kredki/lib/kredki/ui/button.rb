require_relative 'text_pad'

module Kredki
  module UI
    class Button < ShapePad
      extend Forwardable
      extend HasEventResolvers

      class ButtonClickEvent < Event
        model :origin, :<
      end

      class ButtonDownEvent < Event
        model :origin, :<
      end

      class ButtonUpEvent < Event
        model :origin, :<
      end

      param def color! *color
        return color! *Util.cover(yield self.color) if block_given?
        color = Util.uncover color
        return if @color == color
        @color = color
        repaint
        true
      end

      def text
        self[TextPad]
      end

      def << arg
        case arg
        when String
          text << arg
        else
          super
        end
      end

      event_resolver :on_click!, ButtonClickEvent

      flag def down! value = true, event = nil
        return if (c = down) == (value = block_given? ? (yield c) : value == :not ? !c : value)
        @down = value
        report (@down ? ButtonDownEvent.new(event) : ButtonUpEvent.new(event)) if event
        true
      end

      #internal api

      def sketch
        super

        new TextPad, "Button" do
          mousy! false
          h! :fit
          verse_size! 24
          verse_layout! :ycc
        end

        keyboardy!
        stroke_size! 1
        layout! :acc
        wh! :fit
        color! :gray
        m! 3
      end

      def sketch_presence
        super

        Event.each(
          on_focus_enter!, 
          on_focus_leave!, 
          on_mouse_enter!, 
          on_mouse_leave!, 
          on!(ButtonDownEvent), 
          on!(ButtonUpEvent),
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @color
        area.fill_color = down? ? color.darken : mouse_in? ? color.lighten : color
        area.stroke_color = keyboard_in? ? :stroke_focus : color.darken
      end

      def sketch_behavior
        super

        Event.each on_mouse_down!(:primary), on_key_down!(:enter, :space) do |e|
          down! true, e
        end

        on_focus_leave! do |e|
          down! false, e
        end

        on_mouse_up! :primary do |e|
          down = keyboard_in? && ( key_down?(:space) || key_down?(:enter) )
          report ButtonClickEvent.new e if !down && down!(false, e) && !e.drag && include_point?(*layer.translate(*e.xy, self))
        end

        on_key_up! :enter do |e|
          down = pin_top?(:primary) || ( keyboard_in? && key_down?(:space) )
          report ButtonClickEvent.new e if !down && down!(false, e)
        end

        on_key_up! :space do |e|
          down = pin_top?(:primary) || ( keyboard_in? && key_down?(:enter) )
          report ButtonClickEvent.new e if !down && down!(false, e)
        end
      end
    end
  end
end