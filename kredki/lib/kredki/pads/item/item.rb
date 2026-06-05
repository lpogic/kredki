module Kredki
  module Pads
    # Item group member.
    class Item < RectanglePad

      def mixed_set feature
        case feature
        when String
          upper(TextPad)&.set feature or default_text feature
          self.subject ||= feature
          self
        else
          super
        end
      end

      # Get whether is pressed.
      def pressed keyboard_in = nil
        keyboard_in = self.keyboard_in if keyboard_in.nil?
        pin_top :primary or (
          keyboard_in and (
            Kredki.keyboard.pressed? :space or
            Kredki.keyboard.pressed? :enter
          )
        )
      end

      feature :suit # Basic appearance.
      
      def set_suit *suit
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end
      
      def suit
        @suit
      end

      class SelectEvent < Event
        def param
          target.subject
        end
      end

      reaction SelectEvent, :on_select
            
      # :section: LEVEL 2

      def sketch
        super

        set_keyboardy true
        set_layout :xsc
        set_suit :gray
        set_size Fit, 24
        set_margin_x 4
      end

      def presence
        super
        
        Event.each(
          on_focus_enter,
          on_focus_leave,
          on_mouse_press,
          on_mouse_release,
          on_mouse_enter,
          on_mouse_leave,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        if in_disabled
          set opacity: 3/4r
          area.set fill: color
        else
          set opacity: 1r
          area.set fill: pin_in ? color.darken : keyboard_in ? color.lighten : color
        end
      end

      def behavior
        super

        on_mouse_click :primary do |e|
          report_selected e
        end

        behavior_on_key

        on_select do |e|
          e.close if in_disabled
        end
      end

      def behavior_on_key
        on_key_press :space, :enter do |e|
          e.close
        end

        on_key :space, :enter do |e|
          report_selected e
          e.close
        end
      end

      def report_selected e
        report SelectEvent.new(e), lower_enumerator.to_a.reverse
      end

      def mouse_enter e
        lower&.mouse_enter self
      end

      def min_size_x
        fit_size_x
      end

      def default_text text
        put TextPad, text, :text!, mousy: false
      end
    end#Item
  end#Pads
end#Kredki
