require_relative 'pad/pad'
require 'forwardable'

module Kredki
  class UiAction < Action
    extend Forwardable
    
    def initialize **params, &block
      super

      @pads = []
      @mouse_pad = nil
      @keyboard_pad = nil
      @button_pad = nil
    end

    attr :mouse_pad, :keyboard_pad, :button_pad

    def a
      self
    end

    def_delegators :@background,
      :color!, :color=

    def_delegators :window,
      :wh, :size, :w, :width, :h, :height

    def pad! ...
      push_pad(Kredki::Pad.new).sketch_base.alter(...)
    end

    def custom_pad! klass
      push_pad(klass.new).sketch_base
    end

    def push_pad pad, next_pad = nil, clip = true
      index = next_pad && @paints[next_pad]&.index
      push_paint(pad, true, index).alter parent: self, action: action
      if index
        pad_index = ([index, @pads.size].min...0).step(-1).find do |i|
          @paints[@pads[i - 1]].index < index
        end || 0
        @pads.insert pad_index, pad
      else
        @pads << pad
      end
      event_accumulator.load do
        update_point *mouse.position, false
      end
      pad
    end

    def remove_pad pad
      @pads.delete pad
      event_accumulator.load do
        update_point *mouse.position, false
      end
    end

    #internal api

    def sketch p0
      super

      mouse do
        on_move! do |e|
          p0.update_point e.x, e.y, e
        end
      
        on_button! do |e|
          p0.mouse_event PadMouseButtonDownEvent.new e
        end
      
        on_button_up! do |e|
          p0.mouse_event PadMouseButtonUpEvent.new e
        end

        on_drop! do |e|
          p0.mouse_event PadDropEvent.new e, x, y
        end
      end

      keyboard do
        on_down! do |e|
          p0.focus_event e
        end

        on_up! do |e|
          p0.focus_event e
        end

        on_text! do |e|
          p0.focus_event e
        end
      end

      @background = pad! color: :black
      on_resize! do
        @background.size = window.size
      end.call
    end

    def [](filter, &block)
      if block
        each_pad.filter{ _1 =~ filter }.map{ block.call _1 }
      else
        each_pad.find{ _1 =~ filter }
      end
    end

    def each_pad enum = nil
      if enum
        @pads.each{ enum << _1 }
        @pads.each{ _1.each_pad enum }
        enum
      else
        Enumerator.new do |enum|
          each_pad enum
        end
      end
    end

    def update_point x, y, event = nil
      if @button_pad && event
        @button_pad.mouse_event PadMouseMoveEvent.new(event, x, y)
      else
        @mouse_pad = @pads.reverse_each.find{ _1.gain_point x, y, @mouse_pad, event }
      end
    end

    def mouse_event e
      (@button_pad || @mouse_pad)&.mouse_event e
    end

    def gain_focus keyboard_pad = nil
      if @keyboard_pad != keyboard_pad
        @keyboard_pad&.lose_focus
        @keyboard_pad = keyboard_pad
        @keyboard_pad&.event PadFocusGainEvent.new
        return false
      else
        return true
      end
    end

    def focus_event e
      @keyboard_pad&.focus_event e
    end

    def gain_button button_pad = nil
      if @button_pad != button_pad
        @button_pad&.lose_button
        @button_pad = button_pad
        return false
      else
        return true
      end
    end

    def lose_button
      if @button_pad
        @button_pad.lose_button
        @button_pad = nil
      end
    end

    def release_button button_pad = nil
      lose_button if button_pad.nil? || @button_pad == button_pad
    end
  end
end
