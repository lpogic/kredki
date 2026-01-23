require_relative 'text/navigable_text'
require_relative 'portal_layer'

module Kredki
  module UI
    # Control with text transfering click events to selected pad.
    class Label < Pad
      include TextNavigation

      # Set selector for click event target.
      def for! new_for = @for
        return send_ahp :for!, yield(self.for) if block_given?
        return if @for == new_for
        @for = new_for
        true
      end

      # See #for!.
      def for= param
        send_ahp :for!, param
      end

      # Get selector for click event target.
      def for
        @for
      end

      # Set text content.
      def text! text = @text.content
        return send_ahp :text!, yield(self.text) if block_given?
        @text.content! text
      end
      
      # See #text!.
      def text= param
        send_ahp :text!, param
      end

      # Get text content.
      def text
        @text.content
      end

      # Push the feature.
      def << arg
        case arg
        when String
          text! arg
        else
          super
        end
      end
      
      # :section: LEVEL 2

      def initialize
        super

        @text = new NavigableTextPad, h: 1r do
          cursor.w = 0
          mousy! false
        end
      end

      def sketch
        super

        wh! :fit, 24
        for! proc{ it.pa&.fc{ it.keyboardy? } }
        keyboardy! false
        area.fill! false

        text_navigation @text
      end

      def for_pad
        @for.call self
      end

      def behavior
        super

        on_mouse_enter do |event|
          @portal_layer = window.layer! PortalLayer
          @portal_layer.entry = self
          @portal_layer.exit = for_pad
        end
      end
    end
  end
end