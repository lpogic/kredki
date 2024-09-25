require 'forwardable'
require_relative 'margin'

module Kredki
  module UI
    class Button < Margin
      extend Forwardable

      def initialize
        super

        @base_color = nil
      end

      aliasing def color! color
        @base_color = Kredki.color color
        update_color
      end, :color=

      def_delegators :@label,
        :s, :string, :s!, :s=, :string!, :string=

      #internal api

      def sketch p0
        super

        @label = label! s: "Button", mousy: false
    
        on_state!{ update_color }

        body.show!
        alter wh: 5, color: :gray
      end

      def update_color
        body.color = button_top? ? @base_color.dark : mouse_top? ? @base_color.light : @base_color
      end

      def default_on_mouse_button_down e
        super
        report StateEvent.new
      end

      def default_on_mouse_enter e
        super
        report StateEvent.new
      end

      def default_on_mouse_leave e
        super
        report StateEvent.new
      end

      def default_on_mouse_button_up e
        super
        report StateEvent.new
        action.update_mouse_pad e.x, e.y
      end
    end
  end
end