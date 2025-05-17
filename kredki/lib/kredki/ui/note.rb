require 'forwardable'
require_relative 'text/text_line_editor_clip'
require_relative 'theme'

module Kredki
  module UI
    class Note < Pad
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
          kb_in = @pad.keyboard_in?
          @pad.area.color = kb_in ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = kb_in ? :stroke_focus : @color
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

      param_service def cursor
        @text_clip.text.cursor
      end

      param def string! string, cursor = false
        @text_clip.string! string, cursor
      end, get: def string
        @text_clip.string
      end

      #internal api

      def initialize
        super
      
        @text_clip = new TextLineEditorClip, w: 100r, y: 50r
        @theme = nil
      end

      def sketch p0
        super

        mousy!
        stroke_width! 1
        theme! :gray
        h! :fit

        on_mouse_button_up! :primary, aim: true do |e|
          text = @text_clip.text
          if !text.drag? && include_point?(e.x, e.y)
            text.lose_button
            text.report ClickEvent.new e.origin
            e.resolve
          end
        end
      end

      def pad
        @pads.first
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          x -= @clip_scene.x
          y -= @clip_scene.y
          @pads.reverse_each.find{ _1.point_pads x - _1.sx, y - _1.sy, pads, true }
          return true
        end
        return false
      end
    end
  end
end