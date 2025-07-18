require_relative '../text_pad'
require_relative '../theme'
require_relative 'option'

module Kredki
  module UI
    class ContextOption < Option

      def_flag :arrow

      def option!(...)
        dropdown!.option_group.option!(...)
      end

      param def dropdown! ...
        if !@dropdown
          @dropdown = new ContextSecondaryLayer
          new Pad, mousy: false, keyboardy: false, color: 0, x: 100r, h: 100r do
            w! proc{ get_h }
            stroke! color: :text, width: 3, cap: :round, join: :miter
            area! do |w, h|
              move_to! w / 2, h / 3
              line_to! w * 2 / 3, h / 2
              line_to! w / 2, h * 2 / 3
            end
          end
        end
        @dropdown.alter(...)
      end

      #internal api

      def initialize
        super

        @dropdown = nil
      end

      def sketch p0
        super

        on_key_down! :right do |e|
          if @dropdown
            @dropdown.load! self unless @dropdown.loaded?
            @dropdown[Option]&.focus! and e.resolve
          end
        end
      end

      def mouse_enter e
        super
        @dropdown.update_keyboard_pad nil if @dropdown&.loaded?
      end

      def min_w
        @text.fit_w + (@dropdown ? get_h : 0)
      end
    end
  end
end
