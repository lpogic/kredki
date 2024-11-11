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

    def initialize w = 400, h = 400
      @pointer = Abi.window_new w, h
      ObjectSpace.define_finalizer(self, Window.proc.finalize(@pointer))

      Window.init_flags self
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

    def_flag :bordered!
    def_flag :grab

    def fullscreen! method = 0
      Abi.window_set_fullscreen @pointer, method
    end

    aliasing def min_wh! w, h = nil
      set_minimum_size w, h || w
    end, :min_size!

    aliasing def min_wh= wh
      case wh
      when Array then min_wh! *wh
      else min_wh! wh
      end
    end, :min_size=

    aliasing def max_wh! w, h = nil
      set_maximum_size w, h || w
    end, :max_size!

    aliasing def max_wh= wh
      case wh
      when Array then max_wh! *wh
      else max_wh! wh
      end
    end, :max_size=
    
    aliasing def opacity! opacity
      set_opacity opacity > 1 ? opacity / 255.0 : opacity
    end, :opacity=

    aliasing def xy! x, y
      set_position x, y
    end, :position!

    aliasing def xy= xy
      set_position *xy
    end, :position=

    def_flag :resizable

    aliasing def wh! w, h = nil
      set_size w, h || w
    end, :size!

    aliasing def wh= wh
      case wh
      when Array then wh! *wh
      else wh! wh
      end
    end, :size=

    aliasing def wh
      get_size
    end, :size

    aliasing def w! w
      set_size w, h
    end, :w=, :width!, :width=

    aliasing def w
      get_size[0]
    end, :width

    aliasing def h! h
      set_size w, h
    end, :h=, :height!, :height=

    aliasing def h
      get_size[1]
    end, :height

    aliasing def title! title
      set_title title.to_s
    end, :title=

    def_flag :always_top

    aliasing def action! action = nil, &block
      set_action action || Window.default_action.new, &block
    end, :action=

    def action
      @action
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
      @action.owner = self
      Abi.window_set_scene @pointer, action.pointer
      Abi.window_set_step_handler @pointer, action.step_callback
      @action.sketch_base.alter(&block).alter_commit
      update_paint @action
      @action
    end

    def paint_shown? action
      @action == action && !!@arena
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
      Abi::WindowEvent.malloc Fiddle::RUBY_FREE do |abi|
        abi.type = 512
        abi.event = 5
        abi.data1 = width
        abi.data2 = height
        resolve WindowResizeEvent.new abi 
      end
    end

    def get_size
      point = Abi::IntPoint.malloc(Fiddle::RUBY_FREE)
      Abi.window_get_size @pointer, point
      [point.x, point.y]
    end

    def set_title title
      Abi.window_set_title @pointer, title
    end

    def set_always_top top
      Abi.window_set_always_on_top @pointer, top
    end
  end
end
