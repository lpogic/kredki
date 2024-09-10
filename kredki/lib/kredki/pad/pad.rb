require_relative 'pad_events'
require 'forwardable'

module Kredki
  class Pad < Scene
    include Alterable
    include PadEvents
    extend Forwardable

    def initialize **params, &block
      super
      @body = rectangle! x: 0, y: 0
      @id = {}
      @state = :rest
      @on_event = {}

      @pads = []

      @button_down_xy = nil
      @drag
    end

    def sketch p0
      on_enter! do
        default_on_mouse_enter
      end

      on_leave! do
        default_on_mouse_leave
      end

      on_mouse_button! do |e|
        default_on_mouse_button_down e
      end

      on_mouse_button_up! do |e|
        default_on_mouse_button_up e
      end

      on_mouse_move! do |e|
        default_on_mouse_move e
      end
    end

    def sketched?
      @sketched
    end

    def <<(arg)
      case arg
      when Symbol
        if arg.end_with? "!"
          @id.delete arg[...-1].to_sym
        else
          @id[arg] = true
        end
      else
        raise "Unsupported << (#{filter} : #{filter.class})"
      end
    end

    def =~(filter)
      case filter
      when Symbol
        if filter.end_with? "!"
          !@id[filter[...-1].to_sym]
        else
          !!@id[filter]
        end
      else
        raise "Unsupported =~ (#{filter} : #{filter.class})"
      end
    end

    def [](filter, &block)
      if block
        each_pad.filter{ _1 =~ filter }.map{ block.call _1 }
      else
        each_pad.find{ _1 =~ filter }
      end
    end

    def each_pad enum
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

    flag :keyboardy!, true

    def default_on_mouse_button_down e
      gain_focus if keyboardy?
      gain_button
      @button_down_xy = e.xy
      event PadStateEvent.new
    end

    def default_on_mouse_enter
      event PadStateEvent.new
    end

    def default_on_mouse_leave
      event PadStateEvent.new
    end

    def default_on_mouse_button_up e
      release_button
      @button_down_xy = nil
      if @drag
        @drag = false
        event PadDropEvent.new e
      elsif include? e.x, e.y
        event PadClickEvent.new e
      end
      event PadStateEvent.new
    end

    def default_on_mouse_move e
      if @drag
        event PadDragEvent.new e
      elsif @button_down_xy && ((@button_down_xy[0] - e.x) ** 2 + (@button_down_xy[1] - e.y) ** 2 > 100)
        @drag = true
        event PadDragEvent.new e
      end
    end
        

    attr_accessor :parent, :action
    alias_method :a, :action

    attr :state, :body, :mouse_pad, :keyboard_pad, :button_pad, :pads

    def keyboard &block
      Action::Keyboard.new(self, Kredki.keyboard).tap{|k| k.instance_exec &block if block }
    end

    def mouse &block
      Action::Mouse.new(self, Kredki.mouse).tap{|m| m.instance_exec &block if block }
    end

    def clipboard
      Kredki.clipboard
    end

    def include? x, y
      sx = self.x
      sy = self.y
      x > sx && x < sx + @body.w && y > sy && y < sy + @body.h
    end

    def mouse_in?
      parent.mouse_pad == self
    end

    def mouse_top?
      mouse_in? && mouse_pad.nil?
    end

    def keyboard_in?
      parent.keyboard_pad == self
    end

    def keyboard_top?
      keyboard_in? && @keyboard_pad.nil?
    end

    def button_in?
      parent.button_pad == self
    end

    def button_top?
      button_in? && @button_pad.nil?
    end

    flag :mousy!, true
    flag :focus, :set_focus, :keyboard_top?
    flag :button, :set_button, :button_top?

    def drag!
      gain_button
      xy = mouse.xy
      @button_down_xy = xy
      @drag = true
      event PadDragEvent.new(nil, *xy)
    end

    aliasing def x! x
      set_x x
    end, :x=

    aliasing def y! y
      set_y y
    end, :y=

    def xy! x, y
      set_xy x, y
    end

    def xy=(xy)
      xy! *xy
    end

    aliasing def w! w
      if body.w! w
        event_accumulator.load do
          action.update_point *mouse.position, false
          event PadResizeEvent.new
        end if mousy?
        return true
      end
      return false
    end, :w=, :width!, :width=

    aliasing def h! h
      if body.h! h
        event_accumulator.load do
          action.update_point *mouse.position, false
          event PadResizeEvent.new
        end if mousy?
        return true
      end
      return false
    end, :h=, :height!, :height=

    aliasing def wh! w, h = nil
      set_size w, h || w
    end, :size!

    aliasing def wh=(wh)
      case wh
      when Array
        wh! *wh
      else
        wh! wh
      end
    end, :size=

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
      pad.clip! body if clip
      event_accumulator.load do
        action.update_point *mouse.position, false
      end if mousy? && mouse_in?
      pad
    end

    def remove_pad pad
      @pads.delete pad
      event_accumulator.load do
        action.update_point *mouse.position, false
      end if mousy? && mouse_in?
    end

    def detach!
      super
      @parent&.remove_pad self
      @parent = nil
    end

    def use! extension, *a, **na, &b
      extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
    end

    def_delegators :@body,
      :color!, :color=,
      :h, :height, 
      :w, :width,
      :wh, :size,
      :r!, :r=, :radius!, :radius=

    def center! pad = nil
      pad ||= parent
      pad.on_resize! do
        xy! (pad.w - w) / 2, (pad.h - h) / 2
      end.call
    end

    #internal api

    def event_accumulator
      parent&.event_accumulator
    end

    def sketch_base
      sketch self
      @sketched = true
      self
    end
    

    def set_size w, h
      (body.w!(w) | body.h!(h || w)) && begin
        event_accumulator.load do
          action.update_point *mouse.position, false if mousy?
          event PadResizeEvent.new
        end
        true
      end
    end

    def set_x x
      super && begin
        event_accumulator.load do
          action.update_point *mouse.position, false
        end if mousy? && sketched?
        true
      end
    end

    def set_y y
      super && begin
        event_accumulator.load do
          action.update_point *mouse.position, false
        end if mousy? && sketched?
        true
      end
    end

    def set_xy x, y
      super && begin
        event_accumulator.load do
          action.update_point *mouse.position, false
          event PadMoveEvent.new
        end if mousy? && sketched?
        true
      end
    end

    def set_state state
      if @state != state
        @state = state
        event PadStateEvent.new
      end
    end

    def set_show show
      if show
        event PadShowEvent.new
        @pads.each &:show_propagate
      else
        event PadHideEvent.new
        @pads.each &:hide_propagate
      end
      super
    end

    def show_propagate
      if show?
        event PadShowEvent.new
        @pads.each &:show_propagate
      end
    end

    def hide_propagate
      if show?
        event PadHideEvent.new
        @pads.each &:hide_propagate
      end
    end

    def gain_point x, y, current_mouse_pad, event
      if mousy? && show? && include?(x, y)
        if current_mouse_pad == self
          current_mouse_pad.event PadMouseMoveEvent.new(event, x, y) if event
        else
          current_mouse_pad&.mouse_leaved
          mouse_entered
        end
        x -= self.x
        y -= self.y
        mouse_pad = @pads.reverse_each.find{ _1.gain_point x, y, @mouse_pad, event }
        prev_mouse_pad, @mouse_pad = @mouse_pad, mouse_pad
        event PadStateEvent.new if prev_mouse_pad.nil? != mouse_pad.nil?
        return true
      else
        mouse_leaved if current_mouse_pad == self
      end
      return false 
    end

    def mouse_leaved
      @mouse_pad&.mouse_leaved
      event PadLeaveEvent.new
      @mouse_pad = nil
    end

    def mouse_entered
      event PadEnterEvent.new
    end

    def mouse_event e
      (@button_pad || @mouse_pad)&.mouse_event(e.translate self.x, self.y) || event(e)
    end

    def gain_focus keyboard_pad = nil
      if @keyboard_pad != keyboard_pad || keyboard_pad.nil?
        if parent.gain_focus self
          @keyboard_pad&.lose_focus
        end
        @keyboard_pad = keyboard_pad
        event PadStateEvent.new
        keyboard_pad&.event PadFocusGainEvent.new
        return false
      else
        return true
      end
    end

    def lose_focus
      @keyboard_pad&.lose_focus
      event PadFocusLoseEvent.new
      @keyboard_pad = nil
      event PadStateEvent.new
    end

    def release_focus keyboard_pad = nil
      parent.release_focus self if @keyboard_pad == keyboard_pad
    end

    def set_focus set
      set ? gain_focus : release_focus
    end

    def focus_event e
      @keyboard_pad&.focus_event(e) || event(e)
    end

    def gain_button button_pad = nil
      if @button_pad != button_pad || button_pad.nil?
        if parent.gain_button self
          @button_pad&.lose_button
        end
        @button_pad = button_pad
        event PadStateEvent.new
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
      parent.release_button self if @button_pad == button_pad
    end

    def set_button set
      set ? gain_button : release_button
    end

    def translate x, y
      parent.translate x + self.x, y + self. y
    end

    def autosized?
      false
    end
  end
end