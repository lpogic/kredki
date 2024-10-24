require_relative 'margin'
require 'forwardable'

module Kredki
  module UI
    class Input < Margin
      extend Forwardable

      def sketch p0
        super

        @edit = edit! :keyboardy!, autosized: false

        body.show!
        alter wh: 5, color: :gray, stroke_width: 1
        
        repaint_event = proc{ report RepaintEvent.new }
        on_enter! &repaint_event
        on_leave! &repaint_event
        on_focus_gain! &repaint_event
        on_focus_lose! &repaint_event

        on_repaint!(&proc.repaint).resolve

        on_mouse_button_up! mode: :aim do |e|
          if !@edit.drag? && include?(e.x, e.y)
            @edit.lose_button
            e.x -= self.x
            e.y -= self.y
            @edit.report ClickEvent.new e
            e.resolve
          end
        end
      end

      aliasing def color! color
        @base_color = Kredki.color color
        report RepaintEvent.new
      end, :color=

      def repaint
        body.color = mouse_in? ? @base_color.light(20) : @base_color
        body.stroke_color = keyboard_in? ? Kredki.color(:yellow) : @base_color.dark(40)
        # stroke_width: 2, stroke_color: :yellow
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include?(x, y))
          pads << self
          @edit.point_pads x - @edit.x, y - @edit.y, pads, true
          return true
        end
        return false
      end

      def autosized?
        true
      end

      def_delegators :@edit,
        :s!, :s=, :string!, :string=, :s, :string
    end
  end
end