require_relative 'option_group'

module Kredki
  module UI
    class ScrollDropdownLayer < Layer

      def load!
        action = @master.action
        x, y = *@master.translate(0, @master.h)
        if x + @scroll.w > action.w
          x = [action.w - @scroll.w, 0].max
        end
        if y + @scroll.h > action.h
          y = [y - @scroll.h, 0].max
        end
        w = @master.w
        @scroll.alter do
          xy! x, y
          w! w
        end.attach! self
        attach! action
        @scroll.options[Option]&.focus!
      end

      def options
        scroll.options
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

        @scroll = new_pad ScrollPad, :@scroll do
          new_pad Pad, :@options, wh: :fit, color: :gray, layout: Column
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

        @master_events[] = @master.on_focus_gain! do |e|
          load!
        end

        @master_events[] = @master.on_focus_lose! do |e|
          detach!
        end

        @master_events[] = @master.on_key! :left, :right do |e|
          s[Option]&.focus! and e.resolve
        end
      
        @master_events[] = @master.on_click! do |e|
          load! unless show?
        end

        @master_events[] = @master.on_mouse_button! :scroll do |e|
          detach!
        end
  
        @master_events[] = @master.on_key! :down, :up do |e|
          load! unless show?
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