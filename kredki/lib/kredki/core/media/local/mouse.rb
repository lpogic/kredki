module Kredki
  module LocalMedia
    class Mouse
      extend HasFeatures
      extend HasEventResolvers

      model :host, :mouse

      def indexes input
        input.flatten.map{ @mouse.button(_1).to_i }.uniq
      end

      event_resolver def on_move! ...
        @host.on_mouse_move!(...)
      end
      
      event_resolver def on_scroll! ...
        @host.on_mouse_scroll!(...)
      end

      event_resolver def on_down! ...
        @host.on_mouse_down!(...)
      end

      event_resolver def on_up! ...
        @host.on_mouse_up!(...)
      end

      event_resolver def on_drop! ...
        @host.on_drop!(...)
      end

      event_resolver def on_enter! ...
        @host.on_enter!(...)
      end

      event_resolver def on_leave! ...
        @host.on_leave!(...)
      end

      flag def capture! value = true
        return if (c = capture) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_capture value
        true
      end, def capture
        get_capture
      end

      # Set whether the cursor is confined to the window.
      def grab! value = true
        return if (c = grab) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @host.window&.set_mouse_grab value
        true
      end

      # See #grab!.
      def grab= value
        grab! value
      end
      
      # Get whether the cursor is confined to the window.
      def grab
        @host.window&.get_mouse_grab
      end

      # See #grab.
      def grab?
        !!grab
      end

      def x
        xy[0]
      end

      def y
        xy[1]
      end

      def xy
        @host.action.screen_translate *@mouse.xy, @host
      end

      def_delegators :@mouse,
        :down?, :in_window?

      feature_delegate :@mouse, :relative

      # :section: LEVEL 2

      def set_capture capture
        Pastele.mouse_set_capture capture ? 1 : 0
      end

      def get_capture
        w = @host.window
        Pastele.window_get_flags(w.pointer) & 0x4000 != 0 if w
      end
    end
  end
end