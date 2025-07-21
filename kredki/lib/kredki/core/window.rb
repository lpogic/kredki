module Kredki
  class Window
    include Alterable
    extend HasFlags
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

    flag :bordered, nil: true, set: :set_bordered
    flag :grab, set: :set_grab
    flag :fullscreen, nil: false, set: :set_fullscreen

    flag :text_input, nil: false, set: :set_text_input, get: :get_text_input

    param def min_wh! w, h = nil
      set_minimum_size w, h || w
    end

    param def max_wh! w, h = nil
      set_maximum_size w, h || w
    end
    
    param def opacity! opacity
      set_opacity opacity > 1 ? opacity / 255.0 : opacity
    end

    param def xy! x, y
      set_position x, y
    end, false

    flag :resizable, set: :set_resizable

    param def wh! w, h = nil
      set_size w, h || w
    end, def wh
      get_size
    end

    param def w! w
      set_size w, h
    end, def w
      get_size[0]
    end

    param def h! h
      set_size w, h
    end, def h
      get_size[1]
    end

    param def title! title
      set_title title.to_s
    end

    flag :always_top, set: :set_always_top

    param def action! action = nil, ...
      action ||= Window.default_action
      if action.is_a? Class
        action = action.new
        set_action action
        action.sketch action
      else
        set_action action
      end
      
      action.build(...)
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
      @action = action
      @action.scene = self
      Abi.window_set_scene @pointer, action.pointer
      Abi.window_set_step_handler @pointer, action.step_callback
      update_paint @action
      @action
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
    end

    def set_maximum_size x, y
      Abi.window_set_maximum_size @pointer, x, y
    end

    def set_opacity opacity
      Abi.window_set_opacity @pointer, opacity
    end

    def set_position x, y
      Abi.window_set_position @pointer, x, y
    end

    def set_resizable set
      Abi.window_set_resizable @pointer, set ? 1 : 0
      @resizable = set
    end

    def set_size x, y
      Abi.window_set_size @pointer, x, y
    end

    def get_size
      point = Abi::IntPoint.malloc(Fiddle::RUBY_FREE)
      Abi.window_get_size @pointer, point
      [point.x, point.y]
    end

    def set_title title
      Abi.window_set_title @pointer, title
      @title = title
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