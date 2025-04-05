require 'forwardable'
require_relative 'editor'

module Kredki
  module UI
    class TextAreaEditorClip < Pad
      extend Forwardable

      def_delegators :@editor, :on_click!, :on_edit!
      defd_param :@editor, :string
        
      param def tx! position
        @editor.tx! position and update_text
      end, :text_x, get: def tx
        @editor.tx
      end

      param def font_height! height
        @editor.font_height! height and update_text
      end, get: def font_height
        @editor.font_height
      end

      param def h! height
        super and update_text
      end, :height, get: false

      #internal api

      def initialize
        super
        
        @editor = new_pad TextAreaEditor
      end


      def sketch p0
        super

        area.hide!
        
        on_focus_lose! do
          @editor.x = @editor.tx.call @editor.w, w
        end

        on! EditEvent do |e|
          if @editor.w < w
            @editor.x = @editor.tx.call @editor.w, w
          end
        end

        on_mouse_button_up! :primary, aim: true do |e|
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
          x = if pad.w < w then @editor.tx.call w, pad.w
          elsif (l = e.x) < 0 then pad.x - l
          elsif (r = e.w + e.x) > w then pad.x - r + w
          else pad.x
          end
          y = if pad.h < h then 0
          elsif (t = e.y) < 0 then pad.y - t
          elsif (b = e.h + e.y) > h then pad.y - b + h
          else pad.y
          end
          pad.xy! x, y
          e.resolve
        end

        on_scroll! do |e|
          if keyboard_in?
            pad = @editor
            dw = w - pad.w
            dh = h - pad.h
            xo, yo = if dw < 0 && dh < 0
              keyboard.shift? ? [e.y, e.x] : e.xy
            elsif dw < 0
              keyboard.shift? ? [e.yorx, 0] : [e.xory, 0]
            elsif dh < 0
              keyboard.shift? ? [0, e.xory] : [0, e.yorx]
            else
              [0, 0]
            end
            jump = pad.fh / 2
            x = dw < 0 ? (pad.x + xo * jump).clamp(dw, 0) : pad.x
            y = dh < 0 ? (pad.y + yo * jump).clamp(dh, 0) : pad.y
            pad.xy! x, y
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
        @editor.xy! @editor.tx.call(w, @editor.w), 0
      end
    end
  end
end