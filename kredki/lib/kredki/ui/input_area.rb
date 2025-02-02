require 'forwardable'
require_relative 'text/text_area_editor_clip'

module Kredki
  module UI
    class InputArea < Pad
      extend Forwardable

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :@R_base_color, :@N_proc

        def to_proc
          color = @base_color
          @proc ||= proc do
            area.color = mouse_in? ? color.light : color
            area.stroke_color = keyboard_in? ? Kredki.color(:yellow) : color
          end
        end
      end

      aliasing def theme! theme
        theme = case theme
        when Proc, Theme
          theme
        when Symbol, Array
          ColorBasedTheme.new Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          repaint
        end
      end, :theme=

      def theme
        @theme
      end

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

      defw_resp :tx!, :tx=, :string!, :string=, :string

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
                
        begin
          repaint_event = proc{ report RepaintEvent.new }
          on_mouse_enter! &repaint_event
          on_mouse_leave! &repaint_event
          on_focus_gain! &repaint_event
          on_focus_lose! do
            @pads.first&.update_text
            repaint_event.call
          end
        end

        on_repaint! do |e|
          repaint
          e.resolve
        end

        new_pad TextAreaEditorClip, wh: 100r
      end

      def repaint
        instance_exec &@theme
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