require 'forwardable'
require_relative 'text/text_area_editor_clip'

module Kredki
  module UI
    class InputArea < SpacePad
      extend Forwardable

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :base_color_avr!, :proc_a!

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
        new_pad TextAreaEditorClip
      end


      def sketch p0
        super

        mousy!
        area.show!
        wh! 5
        stroke_width! 1
        theme! :gray
                
        begin
          repaint_event = proc{ report RepaintEvent.new }
          on_enter! &repaint_event
          on_leave! &repaint_event
          on_focus_gain! &repaint_event
          on_focus_lose! &repaint_event
        end

        on_repaint! do |e|
          repaint
          e.resolve
        end
      end

      def repaint
        instance_exec &@theme
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          pad = self.pad
          pad.point_pads x - pad.x, y - pad.y, pads, true
          return true
        end
        return false
      end
    end
  end
end