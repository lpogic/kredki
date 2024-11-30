require 'forwardable'
require_relative 'editor'

module Kredki
  module UI
    class TextLineEditorClip < Pad
      extend Forwardable

      def_delegators :@editor,
        :string!, :string=, :string,
        :on_click!, :on_edit!

      attr :editor

      aliasing def tx! position
        position = case position
        when :l, :left then POSITION_START
        when :c, :center then POSITION_CENTER
        when :r, :right then POSITION_END
        when :cs, :center_start then POSITION_CENTER_START
        when Proc then position
        else raise "Invalid #{position.class}[#{position}] given"
        end
        position != @text_x && begin
          @text_x = position
          update_text
          true
        end
      end, :tx=, :text_x!, :text_x=

      aliasing def tx
        @text_x
      end, :text_x

      aliasing def fh! height
        height != @editor.fh && begin
          @editor.fh = height
          update_text
        end
      end, :fh=, :font_height!, :font_height=

      aliasing def fh
        @editor.fh
      end, :font_height

      aliasing def h! height
        super && update_text
      end, :h=, :height!, :height=

      #internal api

      def initialize
        super
        
        @text_x = POSITION_START
        @editor = new_pad TextLineEditor
      end


      def sketch p0
        super

        area.hide!
        h! @editor.h
        
        on_focus_lose! do
          @editor.x = @text_x.call @editor.w, w
        end

        on! EditEvent do |e|
          if @editor.w < w
            @editor.x = @text_x.call @editor.w, w
          end
        end

        on_mouse_button_up! aim: true do |e|
          if !@editor.drag? && include_point?(e.x, e.y)
            @editor.lose_button
            e.x -= self.x
            e.y -= self.y
            @editor.report ClickEvent.new e
            e.resolve
          end
        end

        on! ROIEvent do |e|
          pad = @editor
          if pad.w < w
            pad.x = @text_x.call pad.w, w
          elsif (l = e.x) < 0
            pad.x -= l
          elsif (r = e.w + e.x) > w
            pad.x -= r - w
          end
        end

        on_scroll! do |e|
          if keyboard_in?
            pad = @editor
            if (diff = w - pad.w) < 0
              jump = pad.fh / 2
              x = pad.x + e.xory * jump
              pad.x = x.clamp(diff, 0)
            end
            e.resolve
          end
        end
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include_point?(x, y))
          pads << self
          @editor.point_pads x - @editor.x, y - @editor.y, pads, true
          return true
        end
        return false
      end

      def update_text
        @editor.xy! @text_x.call(@editor.w, w), (h - @editor.h) / 2
      end
    end
  end
end