module Kredki
  module UI
    # Control which state can be on or off.
    class CheckButton < Button

      # Set whether is checked.
      def checked! value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @check.show! value
        @checked = value
        true
      end

      # See #checked!.
      def checked= param
        send_ahp :checked!, param
      end

      # Get whether is checked.
      def checked
        @checked
      end

      # See #checked.
      def checked?
        !!checked
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @check = new RectanglePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
          outline! fill: :text, w: 3
          area! do |w, h|
            xy! w * 0.1, h * 0.5
            line! w * 0.5, h * 0.9
            line! w * 0.9, h * 0.1
          end
          hide!
        end
      end

      def sketch
        super

        layout! :acc
        wh! 20
        m! 3
      end

    end
  end
end