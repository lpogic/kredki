require 'forwardable'
require_relative 'text/text_line_editor_clip'

module Kredki
  module UI
    class Input < Pad
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

      defw_resp :string!, :string=, :string, :tx=, :tx!, :tx
      defw_resp :on_edit!

      #internal api

      def initialize
        super
      
        @editor = new_pad TextLineEditorClip, w: 100r, y: 50r
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
          on_focus_lose! &repaint_event
        end

        on_repaint! do |e|
          repaint
          e.resolve
        end

        h! proc{ @mn + @ms + (pad&.then{ _1.h } || 0) }
        
      end

      def resize e
        if e.target != self
          e.resolve
          update_size
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ update_size }
      end

      def push_pad ...
        super.tap{ update_size }
      end

      def remove_pad pad, transfer
        super.tap{ update_size }
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