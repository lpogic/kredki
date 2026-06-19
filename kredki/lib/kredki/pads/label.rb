require_relative 'portal_layer'

module Kredki
  module Pads
    # Control with text, transfering mouse events to related pad.
    class Label < Pad

      def set_feature feature
        case feature
        when String
          upper(:text!)&.set feature or super
          self.subject ||= feature
        else
          super
        end
      end

      feature :for # Selector for a Pad which the Label describes.
      
      def set_for new_for = @for
        return if @for == new_for
        @for = new_for
        true
      end
      
      def for
        @for
      end

      def sketch
        super

        set_size Fit, 24
        set_for proc{|it| it.lower_pad.upper(Pad, keyboardy: true) }
        set_keyboardy false
        area.set_fill false
      end

      def behavior
        super

        on_mouse_enter do |event|
          @portal_layer = pane.put PortalLayer
          @portal_layer.entry = self
          @portal_layer.exit = for_pad
        end
      end

      def for_pad
        @for.call self
      end

      def default_text text
        put NavigableTextPad, :text!, text, size_y: 1r do
          cursor.size_x = 0
          set_mousy false
        end
      end
    end
  end
end