require_relative 'alterable'
require_relative 'has_flags'
require 'forwardable'
require_relative 'clipboard'
require_relative 'keyboard'
require_relative 'mouse'
require_relative 'action/action'

module Kredki
  class Window
    include Alterable
    extend HasFlags
    extend Forwardable

    def initialize w = 400, h = 400, **params, &block
      @pointer = Abi.window_new w, h
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @bordered = true

      params[:action] ||= Action.new

      alter **params, &block
    end

    attr_accessor :arena

    def inspect
      "#{self.class}:#{object_id}"
    end

    def terminate!
      @arena&.terminate!
    end

    def maximize!
      Abi.window_maximize @pointer
    end

    def minimize!
      Abi.window_minimize @pointer
    end

    def raise!
      Abi.window_raise @pointer
    end

    def restore!
      Abi.window_restore @pointer
    end

    flag :bordered
    flag :grab

    def fullscreen! method = 0
      Abi.window_set_fullscreen @pointer, method
    end

    def min_size! width, height
      set_minimum_size width, height
    end

    def min_size=(size)
      set_minimum_size *size
    end
    
    def max_size! width, height
      set_maximum_size width, height
    end

    def max_size=(size)
      set_maximum_size *size
    end
   
    def opacity!(opacity) = set_opacity opacity > 1 ? opacity / 255.0 : opacity
    alias_method :opacity=, :opacity!

    def position! x, y
      set_position x, y
    end
    
    def position=(position)
      set_position *position
    end

    flag :resizable

    def size! width, height
      set_size width, height
    end

    def size=(size)
      set_size *size
    end

    def size
      get_size
    end

    def width
      get_size[0]
    end

    def height
      get_size[1]
    end

    def title!(title) = set_title title.to_s
    alias_method :title=, :title!

    flag :always_on_top

    def action! action = nil, &block_action
      action ||= Action.new &block_action
      set_action action
    end
    alias_method :action=, :action!
    def action = @action

    def window = self

    def_delegators :@action, 
      :use!,
      :push_paint,
      :push_animation,
      :remove_animation,
      :shape!,
      :ellipse!,
      :rectangle!,
      :fill!,
      :picture!,
      :text!,
      :animation!,
      :scene!,
      :job!,
      :after!,
      :clipboard,
      :keyboard,
      :mouse,
      :joystick,
      :on_step!,
      :on_key_down!,
      :on_key!,
      :on_key_up!,
      :on_mouse_move!,
      :on_mouse_scroll!,
      :on_mouse_button_down!,
      :on_mouse_button!,
      :on_mouse_button_up!,
      :on_text!,
      :on_drop!,
      :on_drop_begin!,
      :on_drop_end!,
      :on_quit!,
      :on_show!,
      :on_hide!,
      :on_expose!,
      :on_move!,
      :on_resize!,
      :on_size_change!,
      :on_minimize!,
      :on_maximize!,
      :on_restore!,
      :on_enter!,
      :on_leave!,
      :on_focus_gein!,
      :on_focus_lose!,
      :on_close!,
      :on_take_focus!,
      :on_hit_test!,
      :on_iccprof_change!,
      :on_display_change!
      

    def <<(paint)
      push_paint paint
    end

    def destroy!
      @arena&.remove_window self
    end

    def_delegators :@arena,
      :window!

    #internal api

    def self.finalize pointer
      Abi.window_delete pointer
    end

    attr :pointer

    def event ...
      @action&.event(...)
    end

    def update_paint paint
      Abi.window_paint_to_update @pointer, paint.pointer
    end

    private

    def set_action action
      @action = action
      @action.owner = self
      Abi.window_set_scene @pointer, action.pointer
      Abi.window_set_step_handler @pointer, action.step_callback
      update_paint action
    end

    def set_bordered bordered
      Abi.window_set_bordered @pointer, bordered
    end

    def set_grab grab
      Abi.window_set_grab @pointer, grab
    end

    def set_maximum_size width, height
      Abi.window_set_maximum_size @pointer, width, height
    end

    def set_minimum_size width, height
      Abi.window_set_minimum_size @pointer, width, height
    end

    def set_opacity opacity
      Abi.window_set_opacity @pointer, opacity
    end

    def set_position x, y
      Abi.window_set_position @pointer, x, y
    end

    def set_resizable resizable
      Abi.window_set_resizable @pointer, resizable
    end

    def set_size width, height
      Abi.window_set_size @pointer, width, height
    end

    def get_size
      point = Abi::IntPoint.malloc(Fiddle::RUBY_FREE)
      Abi.window_get_size @pointer, point
      [point.x, point.y]
    end

    def set_title title
      Abi.window_set_title @pointer, title
    end

    def set_always_on_top on_top
      Abi.window_set_always_on_top @pointer, on_top
    end
  end
end
