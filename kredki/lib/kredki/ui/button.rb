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

      def base_color= color
        @base_color = Kredki.color color
        update_color
      end

      def_delegators :@label,
        :s, :string, :s!, :s=, :string!, :string=

      #internal api

      def sketch p0
        super

        @label = label! s: "Button", mousy: false
    
        on_state!{ update_color }

        body.show!
        alter wh: 5, base_color: :gray
      end

      def update_color
        body.color = button_top? && !drag? ? @base_color.dark : mouse_top? ? @base_color.light : @base_color
      end
    end
  end
end