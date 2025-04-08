require 'forwardable'
require_relative 'text/text_area_editor_clip'
require_relative 'theme'

module Kredki
  module UI
    class InputArea < Pad
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

      #internal api

      def initialize
        super
      
        @theme = nil
      end


      def sketch p0
        super

        mousy!
        stroke_width! 1
        theme! :gray
                
        on_focus_lose!{ @pads.first&.update_text }

        new_pad TextAreaEditorClip, wh: 100r
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