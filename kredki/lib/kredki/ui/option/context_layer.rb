require_relative 'option_group'

module Kredki
  module UI
    class ContextLayer < Layer

      def load! x, y
        x_max = action.w - @options.sw 
        x = [x_max, 0].max if x > x_max
        sh = @options.sh
        y = [y - sh, 0].max if y + sh > action.h
        @options.alter do
          xy! x, y
        end.attach! self
        action.push_layer self
      end

      def unload!
        pad_detach
      end

      def loaded?
        !!@pad_parent
      end

      def option! ...
        @options.option!(...)
      end

      def options
        @options
      end

      #internal api

      def initialize
        super

        @options = new_pad Pad, wh: :fit, color: :gray, layout: :column
      end

      def sketch p0
        super

        on_key! :escape do
          detach!
        end

        on! Option::PickEvent do
          detach!
        end
      end

      def set_master master
        @master_events&.each{ _1.detach! }
        @master_events = []

        @master_events[] = master.on_mouse_button! :secondary do |e|
          load! *master.translate(*e.xy)
          s[Option]&.focus!
          e.resolve
        end
  
        @master_events[] = master.on_key! :context do |e|
          load! *master.translate(@master.sw / 2, @master.sh / 2)
          s[Option]&.focus!
          e.resolve
        end

      end

      def mouse_button_down e
        detach!
      end

      def mouse_button_up e
      end

      def group
        @group ||= OptionGroup[:up, :down]
      end
    end
  end
end