module Kredki
  module UI
    class DroprightLayer < Layer

      def load!
        action = @master.action
        x, y = *@master.translate(@master.w, 0)
        if x + @options.w > action.w
          x = [x - @master.w - @options.w, 0].max
        end
        if y + @options.h > action.h
          y = [action.h - @options.h, 0].max
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
          options = Options[]

          define_singleton_method :option! do |*a, **na, &b|
            super *a, group: options, **na, &b
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
            e.resolve
          end
        end

        @master_events[] = @master.on_focus_gain! do |e|
          load!
        end

        @master_events[] = @master.on_focus_lose! do |e|
          detach!
        end

        @master_events[] = @master.on_key! :right do |e|
          load! unless show?
          s[Option]&.focus! and e.resolve
        end

        @master_events[] = @master.on_key! :left do |e|
          detach!
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