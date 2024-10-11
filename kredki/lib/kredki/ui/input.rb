require_relative 'margin'
require 'forwardable'

module Kredki
  module UI
    class Input < Margin
      extend Forwardable

      def sketch p0
        super

        @edit = edit! autosized: false
    
        on_repaint! do
          color = Kredki.color :gray
          body.color = mouse_in? ? color.light(20) : color
        end.resolve

        on_enter! do
          report RepaintEvent.new
        end

        on_leave! do
          report RepaintEvent.new
        end

        on_mouse_button_up! mode: :aim do |e|
          if !@edit.drag? && include?(e.x, e.y)
            @edit.lose_button
            e.x -= self.x
            e.y -= self.y
            @edit.report ClickEvent.new e
          else
            e.forward
          end
        end

        body.show!
        alter wh: 5, color: :gray
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