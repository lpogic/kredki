module Kredki
  class Action
    class Mouse
      model :action, :mouse

      def indexes *input
        input.flatten.map{ @mouse.index _1 }.uniq
      end

      def on_move! ...
        @action.on_mouse_move!(...)
      end
      
      def on_scroll! ...
        @action.on_mouse_scroll!(...)
      end

      def on_button! ...
        @action.on_mouse_button!(...)
      end

      alias_method :on_button_down!, :on_button!

      def on_button_up! ...
        @action.on_mouse_button_up!(...)
      end

    end
  end
end