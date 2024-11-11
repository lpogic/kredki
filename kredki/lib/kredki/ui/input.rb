require 'forwardable'

module Kredki
  module UI
    class Input < Pad
      extend Forwardable

      def initialize
        super
        
        @text_x = POSITION_START
        @editor = new_pad TextLineEditor, :keyboardy!
      end


      def sketch p0
        super

        alter h: @editor.h, color: :gray, stroke_width: 1
        
        repaint_event = proc{ report RepaintEvent.new }
        on_enter! &repaint_event
        on_leave! &repaint_event
        on_focus_gain! &repaint_event
        on_focus_lose! do
          repaint_event.call
          @editor.x = @text_x.call @editor.w, w
        end

        on_repaint!(&proc.repaint).resolve

        w_before_edit = 0
        on! EditEvent, aim: true do |e|
          w_before_edit = @editor.w
        end

        on! EditEvent do |e|
          if @editor.w < w
            @editor.x = @text_x.call @editor.w, w
          end
        end

        on_mouse_button_up! aim: true do |e|
          if !@editor.drag? && include?(e.x, e.y)
            @editor.lose_button
            e.x -= self.x
            e.y -= self.y
            @editor.report ClickEvent.new e
            e.resolve
          end
        end

        on! ROIEvent do |e|
          pad = @editor
          p [e.xy, e.wh]
          if pad.w < w
            pad.x = @text_x.call pad.w, w
          elsif (l = e.x) < 0
            pad.x -= l
          elsif (r = e.w + e.x) > w
            pad.x -= r - w
          end
        end
      end

      aliasing def color! color
        @base_color = Kredki.color color
        report RepaintEvent.new
      end, :color=

      def repaint
        body.color = mouse_in? ? @base_color.light(20) : @base_color
        body.stroke_color = keyboard_in? ? Kredki.color(:yellow) : @base_color.dark(40)
      end

      def point_pads x, y, pads, force = false
        if force || (mousy? && show? && include?(x, y))
          pads << self
          @editor.point_pads x - @editor.x, y - @editor.y, pads, true
          return true
        end
        return false
      end

      def_delegators :@editor,
        :s!, :s=, :string!, :string=, :s, :string,
        :on_click!, :on_edit!

      attr :editor

      def update_text
        @editor.xy! @text_x.call(@editor.w, w), (h - @editor.h) / 2
      end

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
          true
        end
      end, :fh=, :font_height!, :font_height=

      aliasing def fh
        @lines.first.text.h
      end, :font_height

      aliasing def h! height
        super && update_text
      end, :h=, :height!, :height=
    end
  end
end