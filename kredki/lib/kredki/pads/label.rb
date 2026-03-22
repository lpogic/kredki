require_relative 'text/navigable_text'
require_relative 'portal_layer'

module Kredki
  module Pads
    # Control with text transfering click events to selected pad.
    class Label < Pad
      include TextNavigation

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

      # Set text content.
      def set_text text = @text.subject
        return send_bundle :set_text, yield(self.text) if block_given?
        @text.subject = text
      end
      
      # See #set_text.
      def text= param
        send_bundle :set_text, param
      end

      # Get text content.
      def text
        @text.content
      end

      # Set a feature recognized by its class.
      def << arg
        case arg
        when String
          set_text arg
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def initialize
        super

        @text = put NavigableTextPad, size_y: 1r do
          cursor.size_x = 0
          set_mousy false
        end
      end

      def sketch
        super

        set_size Fit, 24
        set_for proc{|it| it.lower_pad&.find{|it| it.keyboardy } }
        set_keyboardy false
        area.set_fill false

        text_navigation @text
      end

      def for_pad
        @for.call self
      end

      def behavior
        super

        on_mouse_enter do |event|
          @portal_layer = pane.layer! PortalLayer
          @portal_layer.entry = self
          @portal_layer.exit = for_pad
        end
      end
    end
  end
end