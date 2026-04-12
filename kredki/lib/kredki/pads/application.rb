module Kredki
  module Pads
    # Application of Pads module.
    class Application < Kredki::Application
      
      # :section: LEVEL 2

      def default_window
        Window.new
      end
    end
  end
end