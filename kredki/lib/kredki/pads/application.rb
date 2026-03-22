module Kredki
  module Pads
    # Application of Pads module.
    class Application < Kredki::Application
      
      def default_window
        Window.new
      end
    end
  end
end