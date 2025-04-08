require 'forwardable'
require_relative 'text/text_line_editor_clip'
require_relative 'theme'

module Kredki
  module UI
    class Input < Pad
      extend Forwardable

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_gain!,
            pad.on_focus_lose!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.area.color = @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = @pad.keyboard_in? ? Kredki.color(:yellow) : @color
        end
      end

      def color_theme color
        SimpleColorBasedTheme.new color
      end

      param def theme! theme
        theme = case theme
        when Theme
          theme
        when Symbol, Array
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          theme.attach! self
        end
      end

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

      defw_param :string, :tx, :text_x
      defw_resp :on_edit!

      #internal api

      def initialize
        super
      
        @editor = new_pad TextLineEditorClip, w: 100r, y: 50r
        @theme = nil
      end

      attr :editor

      def sketch p0
        super

        mousy!
        stroke_width! 1
        theme! :gray

        h! proc{ @mn + @ms + (pad&.then{ _1.h } || 0) }
      end

      def resize e
        if e.target != self
          e.resolve
          set_size or arrange
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ set_size }
      end

      def push_pad ...
        super.tap{ set_size }
      end

      def remove_pad pad, transfer
        super.tap{ set_size }
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          @pads.reverse_each.find{ _1.point_pads x - _1.x, y - _1.y, pads, true }
          return true
        end
        return false
      end
    end
  end
end