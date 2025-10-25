module Kredki
  class Window
    extend HasParams
    extend Forwardable

    def initialize w = 400, h = 400
      @pointer = Abi.window_new w, h
      ObjectSpace.define_finalizer(self, Window.proc.finalize(@pointer))
    end

    class << self
      attr_accessor :default_action
    end

    self.default_action = Action

    attr_reader :arena

    def terminate! result = nil
      @arena&.terminate! result
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

    flag def bordered! value = true
      return if (c = bordered) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_bordered value
      @bordered = value
      true
    end, def bordered
      @bordered || @bordered.nil?
    end

    flag def grab! value = true
      return if (c = grab) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_grab value
      @grab = value
      true
    end

    flag def fullscreen! value = true
      return if (c = fullscreen) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_fullscreen value
      @fullscreen = value
      true
    end

    flag def text_input! value = true
      return if (c = text_input) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_text_input value
      true
    end, def text_input
      get_text_input
    end
    
    def min_wh! w, h = nil
      set_minimum_size w, h || w
    end

    def max_wh! w, h = nil
      set_maximum_size w, h || w
    end
    
    def opacity! opacity
      set_opacity opacity > 1 ? opacity / 255.0 : opacity
    end

    param def xy! *xy
      return xy! *Util.cover(yield self.xy) if block_given?
      case xy.size
      when 0 then return
      when 1
        x = y = xy[0]
      when 2
        x = xy[0]
        y = xy[1]
      else
        raise_ia xy
      end
      set_position x, y
    end, def xy
      get_position
    end

    flag def resizable! value = true
      return if (c = resizable) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_resizable value
      @resizable = value
      true
    end

    param def wh! *wh
      return wh! *Util.cover(yield self.wh) if block_given?
      case wh.size
      when 0 then return
      when 1
        w = h = wh[0]
      when 2
        w = wh[0]
        h = wh[1]
      else
        raise_ia wh
      end
      set_size w, h
    end, def wh
      get_size
    end

    param def w! w = nil
      return w! yield self.w if block_given?
      set_size w, h
    end, def w
      get_size[0]
    end

    param def h! h = nil
      return h! yield self.h if block_given?
      set_size w, h
    end, def h
      get_size[1]
    end

    param def title! title = nil
      return title! yield self.title if block_given?
      return if @title == title
      set_title title.to_s
      @title = title
      true
    end

    flag def always_top! value = true
      return if (c = always_top) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_always_top value
      @always_top = value
      true
    end

    param def action! action = nil, ...
      action ||= Window.default_action
      if action.is_a? Class
        action = action.new
        set_action action
        action.sketch action
      else
        set_action action
      end
      
      action.main.alter(...)
    end

    def window
      self
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

    attr_writer :arena
    attr :pointer

    def_delegators :action,
      :resolve

    def update_paint paint
      Abi.window_paint_to_update @pointer, paint.pointer
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def set_action action, &block
      action.scene = self
      Abi.window_set_scene @pointer, action.pointer
      Abi.window_set_step_handler @pointer, action.step_callback
      update_paint action
      @action = action
    end

    def paint_shown action, direct
      @action == action && !!@arena
    end

    def set_bordered set
      Abi.window_set_bordered @pointer, set ? 1 : 0
      @bordered = set
    end

    def set_grab set
      Abi.window_set_grab @pointer, set ? 1 : 0
      @grab = set
    end

    def set_fullscreen set
      Abi.window_set_fullscreen @pointer, set ? 1 : 0
      @fullscreen = set
    end

    def set_minimum_size x, y
      Abi.window_set_minimum_size @pointer, x, y
      true
    end

    def set_maximum_size x, y
      Abi.window_set_maximum_size @pointer, x, y
      true
    end

    def set_opacity opacity
      Abi.window_set_opacity @pointer, opacity
      true
    end

    def set_position x, y
      Abi.window_set_position @pointer, x, y
      true
    end

    def get_position
      point = Abi::IntPoint.malloc(Fiddle::RUBY_FREE)
      Abi.window_get_position @pointer, point
      [point.x, point.y]
    end

    def set_resizable set
      Abi.window_set_resizable @pointer, set ? 1 : 0
    end

    def set_size x, y
      Abi.window_set_size @pointer, x, y
      true
    end

    def get_size
      point = Abi::IntPoint.malloc(Fiddle::RUBY_FREE)
      Abi.window_get_size @pointer, point
      [point.x, point.y]
    end

    def set_title title
      Abi.window_set_title @pointer, title
      true
    end

    def set_always_top set
      Abi.window_set_always_on_top @pointer, set ? 1 : 0
      @always_top = set
    end

    def set_text_input set
      Abi.window_set_text_input @pointer, set ? 1 : 0
    end

    def get_text_input
      Abi.window_get_text_input(@pointer) != 0
    end
  end
end