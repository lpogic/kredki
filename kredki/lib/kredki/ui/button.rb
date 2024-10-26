require 'forwardable'
require_relative 'margin'
require_relative 'label'

module Kredki
  module UI
    class Button < Pad
      extend Forwardable

      aliasing def color! color
        @base_color = Kredki.color color
        report RepaintEvent.new
      end, :color=

      aliasing def s! s
        if pad.respond_to? :s!
          pad.s! s
        else
          new_pad(Label).alter s:, mousy: false
        end
      end, :s=, :string!, :string=

      aliasing def s
        if pad.respond_to? :s
          pad.s
        end
      end, :string

      def << arg
        case arg
        when String
          s! arg
        else
          super
        end
      end

      #internal api

      def initialize
        super

        @base_color = nil
      end

      def sketch p0
        super

        keyboardy!
        string! "Button"
        
        color! :gray
        stroke_width! 1

        on_resize! do |e|
          if e.target != self
            update_pad
            e.resolve
          end
        end

        on_repaint! do |e|
          update_color
          e.resolve
        end
        update_color

        on_focus_gain! do |e|
          report RepaintEvent.new
          e.resolve
        end

        on_focus_lose! do |e|
          report RepaintEvent.new
          e.resolve
        end
      end

      def pad
        @pads.first
      end

      def push_pad ...
        pad&.detach! true
        result = super
        update_pad
        result
      end

      def remove_pad pad, transfer
        result = super
        update_pad unless transfer
        result
      end

      def update_pad
        pad = self.pad
        if pad
          set_size *pad.wh
        else
          set_size 0, 0
        end
      end

      def update_color
        stroke_color! keyboard_top? ? :yellow : @base_color.dark(20)
        body.color! button_top? ? @base_color.dark : mouse_in? ? @base_color.light : @base_color
      end

      def mouse_button_down e
        super
        report RepaintEvent.new
      end

      def mouse_enter e
        super
        report RepaintEvent.new
      end

      def mouse_leave e
        super
        report RepaintEvent.new
      end

      def mouse_button_up e
        super
        report RepaintEvent.new
      end
    end
  end
end