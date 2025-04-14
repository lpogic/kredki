require 'forwardable'
require_relative 'editor'

module Kredki
  module UI
    class TextLineEditorClip < Pad
      extend Forwardable


      def_delegators :@editor, :on_click!, :on_edit!

      param def string! string, cursor = false
        @editor.string! string, cursor
      end, get: def string
        @editor.string
      end

      attr :editor

      param def tx! position
        position = case position
        when :l, :left then POSITION_START
        when :c, :center then POSITION_CENTER
        when :r, :right then POSITION_END
        when :cs, :center_start then POSITION_CENTER_START
        when Proc then position
        else raise "Invalid #{position.class}[#{position}] given"
        end
        position != @tx && begin
          @tx = position
          update_text
          true
        end
      end, :text_x

      param def font_height! height
        height != @editor.font_height and begin
          @editor.font_height! height
          update_text
        end
      end, get: def font_height
        @editor.font_height
      end

      param def h! height
        super and update_text
      end, :height, get: false

      def text
        @editor
      end

      #internal api

      def initialize
        super
        
        @tx = POSITION_START
        @editor = new_pad TextLineEditor
      end


      def sketch p0
        super

        area.hide!
        h! @editor.h
        
        on_focus_lose! do
          @editor.x = @tx.call w, @editor.w
        end

        on! EditEvent do |e|
          if @editor.w < w
            @editor.x = @tx.call w, @editor.w
          end
        end

        on_mouse_button_up! :primary, aim: true do |e|
          if !@editor.drag? && include_point?(e.x, e.y)
            @editor.lose_button
            e.x -= sx
            e.y -= sy
            @editor.report ClickEvent.new e
            e.resolve
          end
        end

        on! ROIEvent do |e|
          pad = @editor
          if pad.sw < w
            pad.x = @tx.call w, pad.w
          elsif (l = e.x) < 0
            pad.x -= l
          elsif (r = e.w + e.x) > w
            pad.x -= r - w
          end
        end

        on_scroll! do |e|
          if keyboard_in? && keyboard.shift?
            pad = @editor
            if (diff = w - pad.sw) < 0
              jump = pad.sh / 2
              x = pad.sx + e.xory * jump
              pad.x = x.clamp(diff, 0)
            end
            e.resolve
          end
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          @editor.point_pads x - @editor.sx, y - @editor.sy, pads, true
          return true
        end
        return false
      end

      def update_text
        @editor.xy! @tx.call(w, @editor.sw), (h - @editor.sh) / 2
      end
    end
  end
end