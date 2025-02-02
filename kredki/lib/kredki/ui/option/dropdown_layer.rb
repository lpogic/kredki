module Kredki
  module UI
    class DropdownLayer < Layer

      def load!
        action = @master.action
        x, y = *@master.translate(0, @master.h)
        if x + @options.w > action.w
          x = [action.w - @options.w, 0].max
        end
        if y + @options.h > action.h
          y = [y - @options.h, 0].max
        end
        @options.alter do
          xy! x, y
        end.attach! self
        attach! action
      end

      def options
        @options
      end

      aliasing def master! master
        @master != master and set_master master
      end, :master=

      #internal api

      def initialize
        super
      end

      def sketch p0
        super

        @options = new_pad Pad, wh: :fit, color: :gray, layout: Column do
          options = OptionGroup[]

          define_singleton_method :option! do |*a, **na, &b|
            super *a, group: options, **na, &b
          end
          
          define_singleton_method :opt! do |*a, **na, &b|
            option!(*a, w: 100r, m: 5, **na).dropright! &b
          end
        end

        on_key! :escape do
          detach!
        end
        on! Option::PickEvent do |e|
          detach!
          @master&.report e
        end
      end

      def set_master master
        @master_events&.each{ _1.detach! }
        @master = master
        @master_events = []

        @master_events[] = @master.on_pick! do |e|
          if e.target == @master
            load!
            s[Option]&.focus!
            e.resolve
          end
        end

        @master_events[] = @master.on_focus_gain! do |e|
          load!
          s[Option]&.focus!
        end

        @master_events[] = @master.on_focus_lose! do |e|
          detach!
        end

        @master_events[] = @master.on_key! :down do |e|
          s[Option]&.focus! and e.resolve
        end
      end

      def mouse_button_down e
        detach!
      end

      def mouse_button_up e
      end
    end
  end
end