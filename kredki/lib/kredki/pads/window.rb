module Kredki
  module Pads
    # Window of Pads module.
    class Window < Kredki::Window
      
      def default_pane
        Pane.new
      end
    end
  end
end