require_relative 'text/navigable_text'
require_relative 'portal_layer'

module Kredki
  module Pads
    # Control with text transfering click events to selected pad.
    class Label < Pad

      # Set selector for click event target.
      def set_for new_for = @for
        return send_bundle :set_for, yield(self.for) if block_given?
        return if @for == new_for
        @for = new_for
        true
      end

      # See #set_for.
      def for= param
        send_bundle :set_for, param
      end

      # Get selector for click event target.
      def for
        @for
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when String
          set_subject{|it| it || feature }
          text?&.set feature or super
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def sketch
        super

        set_size Fit, 24
        set_for proc{|it| it.lower_pad&.find{|it| it.keyboardy } }
        set_keyboardy false
        area.set_fill false
      end

      def for_pad
        @for.call self
      end

      def behavior
        super

        on_mouse_enter do |event|
          @portal_layer = pane.put PortalLayer
          @portal_layer.entry = self
          @portal_layer.exit = for_pad
        end
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